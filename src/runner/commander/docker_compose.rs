use std::process::exit;

use crate::{runner::runner_app, settings::Settings};

pub fn run_action(settings: &Settings, service: &str, command: &str) {
    let projects_root_path = settings.projects_root_path.clone();
    let formatted_runner_path = runner_app::format_runner_path(projects_root_path.clone());
    let mut command_actual = command.to_string();
    let mut environment_variables_mapping: Vec<(String, String)> = Vec::new();

    if command.starts_with("up") {
        if settings
            .docker_compose_overrides
            .always_rebuild
            .contains(&service.to_string())
            && !command.contains("--build")
        {
            command_actual = format!("{} --build", command);
        }

        environment_variables_mapping = resolve_environment_values_mapping(settings, service);
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
    println!(
        "> {}{} → {}docker compose {}",
        formatted_runner_path, service, environment_variables_injection, command_actual
    );

    runner_app::run_command(
        &format!(
            "docker compose -f {}/{}/docker-compose.yml {}",
            projects_root_path, service, command_actual
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

    let output = runner_app::get_command_output(&format!(
        "docker compose -f {}/{}/docker-compose.yml ps --format json",
        projects_root_path, service
    ));
    let json_obj = serde_json::from_str::<serde_json::Value>(output.as_str()).unwrap();

    // Output arrays
    let mut ports: Vec<String> = Vec::new();
    let mut service_names: Vec<String> = Vec::new();

    for container in json_obj.as_array().unwrap() {
        let project_name = container["Project"].to_string().replace('\"', "");

        if project_name != service {
            println!(
                "DEBUG: resolve_service_exposed_ports(): {} != {}",
                project_name, service
            );
            exit(1);
        }

        let service_name = container["Service"].to_string().replace('\"', "");
        let container_publishers = container["Publishers"].as_array().unwrap();
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
