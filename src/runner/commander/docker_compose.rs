use std::process::exit;

use crate::{runner::runner_app, settings::Settings};

pub fn run_action(settings: &Settings, service: &str, command: &str) {
    let projects_root_path = settings.projects_root_path.clone();
    let formatted_runner_path = runner_app::format_runner_path(projects_root_path.clone());
    let mut command_actual = command.to_string();
    let mut environment_variables_mapping: Vec<(String, String)> = Vec::new();
    let (service_actual, docker_compose_file, docker_service_selections) =
        resolve_service_and_docker_compose_file(service);

    if command.starts_with("up") {
        if settings
            .docker_compose_overrides
            .always_rebuild
            .contains(&service_actual)
            && !command.contains("--build")
        {
            command_actual = format!("{} --build", command);
        }

        environment_variables_mapping =
            resolve_environment_values_mapping(settings, &service_actual);
    }

    let mut environment_variables_injection = String::new();
    if !environment_variables_mapping.is_empty() {
        for environment_variable in environment_variables_mapping.iter() {
            environment_variables_injection = format!(
                "{}={} {}",
                environment_variable.0, environment_variable.1, environment_variables_injection
            );
        }
    }
    let mut docker_service_selections_string = docker_service_selections.join(" ");
    if !docker_service_selections_string.is_empty() {
        docker_service_selections_string = format!(" {}", docker_service_selections_string);
    }

    let mut print_compose_file_prefix = String::new();
    if docker_compose_file != "docker-compose.yml" {
        print_compose_file_prefix = format!("-f {} ", docker_compose_file);
    }

    println!(
        "> {}{} → {}docker compose {}{}{}",
        formatted_runner_path,
        service_actual,
        environment_variables_injection,
        print_compose_file_prefix,
        command_actual,
        docker_service_selections_string
    );

    runner_app::run_command(
        &format!(
            "docker compose -f {}/{}/{} {}{}",
            projects_root_path,
            service_actual,
            docker_compose_file,
            command_actual,
            docker_service_selections_string
        ),
        false,
        Some(environment_variables_mapping),
    );
}

fn resolve_environment_values_mapping(settings: &Settings, service: &str) -> Vec<(String, String)> {
    let mut environment_variables_mapping: Vec<(String, String)> = Vec::new();

    if !settings.docker_compose_overrides.environment.is_empty() {
        for environment in settings.docker_compose_overrides.environment.iter() {
            let mut conditions_met = true;

            if environment.conditions.is_some() {
                for condition in environment.conditions.as_ref().unwrap().iter() {
                    if condition.key == "service" && condition.value != service {
                        conditions_met = false;
                        break;
                    }

                    // https://doc.rust-lang.org/std/env/consts/constant.ARCH.html
                    if condition.key == "arch" && condition.value != std::env::consts::ARCH {
                        conditions_met = false;
                        break;
                    }
                }
            }

            if conditions_met {
                environment_variables_mapping
                    .push((environment.key.clone(), environment.value.clone()));
            }
        }
    }

    environment_variables_mapping
}

pub fn resolve_service_exposed_infos(settings: &Settings, service: &str) -> Vec<(String, String)> {
    let mut hosts_with_service_ports: Vec<(String, String)> = Vec::new();

    let projects_root_path = settings.projects_root_path.clone();
    let (service_actual, docker_compose_file, _) = resolve_service_and_docker_compose_file(service);

    let mut output = runner_app::get_command_output(&format!(
        "docker compose -f {}/{}/{} ps --format json",
        projects_root_path, service_actual, docker_compose_file
    ));

    // Fix for docker compose bug that returns array values as strings separated by newlines (on some platforms)
    if !output.starts_with("[\"") && !output.ends_with("\"]") && output.contains("{\"Command\":") {
        output = format!("[{}]", output.replace('\n', ","));
        // Replace last trailing comma with empty string
        output = output[..output.len() - 2].to_string() + "]";
    }

    let json_obj = serde_json::from_str::<serde_json::Value>(output.as_str());
    if json_obj.is_err() {
        println!("DEBUG: resolve_service_exposed_ports(): {}", output);
        exit(1);
    }

    // Output arrays
    let mut ports: Vec<String> = Vec::new();
    let mut service_names: Vec<String> = Vec::new();

    for container_value in json_obj.unwrap().as_array().unwrap() {
        let container = container_value
            .as_object()
            .expect("Failed to parse service container output");
        if !container.contains_key("Project")
            || !container.contains_key("Service")
            || !container.contains_key("Publishers")
        {
            break;
        }

        let project_name = container["Project"].to_string().replace('\"', "");

        if project_name != service {
            println!(
                "DEBUG: resolve_service_exposed_ports(): {} != {}",
                project_name, service
            );
            exit(1);
        }

        let service_name = container["Service"].to_string().replace('\"', "");
        let container_publishers = container["Publishers"]
            .as_array()
            .expect("Failed to parse service publishers output");
        for publisher in container_publishers {
            let port = publisher["PublishedPort"].to_string().replace('\"', "");
            if port == "0" {
                continue;
            }
            if !ports.contains(&port) {
                ports.push(port);
                service_names.push(service_name.clone());
            }
        }
    }

    for (index, port) in ports.iter().enumerate() {
        hosts_with_service_ports.push((service_names[index].to_owned(), port.to_owned()));
    }

    hosts_with_service_ports
}

fn resolve_service_and_docker_compose_file(service: &str) -> (String, String, Vec<String>) {
    let mut service_actual = service.to_string();
    let mut docker_compose_file = "docker-compose.yml".to_string();
    let mut docker_service_names = Vec::<String>::new();

    if service.contains(':') {
        let service_parts: Vec<&str> = service.split(':').collect();

        if service_parts.len() != 2 {
            panic!("Invalid service format. Expected format: service[:docker-compose-file]");
        }

        service_actual = service_parts[0].to_string();
        let docker_compose_file_part = service_parts[1].to_string();
        let docker_compose_file_parts: Vec<&str> = docker_compose_file_part
            .split(',')
            .map(|s| s.trim())
            .collect();

        // Service selection syntax validation
        let docker_compose_file_parts_that_end_with_dot_yml = docker_compose_file_parts
            .iter()
            .filter(|s| s.ends_with(".yml"))
            .collect::<Vec<&&str>>();
        if !docker_compose_file_parts_that_end_with_dot_yml.is_empty() {
            if docker_compose_file_parts_that_end_with_dot_yml.len() > 1 {
                panic!("Invalid service format. Only 1 docker-compose file can be specified. Expected format: service[:docker-compose-file.yml, docker-compose-service1, service2 ...]");
            }

            if !docker_compose_file_parts[0].ends_with(".yml") {
                panic!("Invalid service format. Expected format: service[:docker-compose-file.yml, docker-compose-service1, service2 ...]");
            }
        }

        let mut services_index = 0;
        if docker_compose_file_parts[0].ends_with(".yml") {
            docker_compose_file = docker_compose_file_parts[0].to_string();
            services_index = 1;
        }

        docker_service_names = docker_compose_file_parts[services_index..]
            .iter()
            .map(|s| s.to_string())
            .collect();
    }

    (service_actual, docker_compose_file, docker_service_names)
}
