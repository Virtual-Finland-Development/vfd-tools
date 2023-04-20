use std::process::exit;

use crate::{runner::runner_app, settings::Settings};

pub fn run_action(settings: &Settings, service: &str, command: &str) {
    let projects_root_path = settings.projects_root_path.clone();
    let formatted_runner_path = runner_app::format_runner_path(projects_root_path.clone());
    let mut command_actual = command.to_string();

    if command.starts_with("up")
        && settings
            .docker_compose_overrides
            .always_rebuild
            .contains(&service.to_string())
        && !command.contains("--build")
    {
        command_actual = format!("{} --build", command);
    }

    println!(
        "> {}{} → docker compose {}",
        formatted_runner_path, service, command_actual
    );
    runner_app::run_command(
        &format!(
            "docker compose -f {}/{}/docker-compose.yml {}",
            projects_root_path, service, command_actual
        ),
        false,
    );
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
