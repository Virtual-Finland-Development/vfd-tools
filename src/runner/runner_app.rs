use super::commander::docker_compose::resolve_service_exposed_infos;
use super::traefik;
use crate::settings::Settings;
use std::{
    env,
    process::{Command, Stdio},
};

pub fn run_command(
    command: &str,
    quiet: bool,
    environment_variables_mapping: Option<Vec<(String, String)>>,
) {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();

    let mut binding = Command::new(primary_command);
    let command = binding.args(command_parts);

    if quiet {
        command.stdout(Stdio::null()).stderr(Stdio::null());
    } else {
        command.stdout(Stdio::inherit()).stderr(Stdio::inherit());
    }

    if let Some(environments) = environment_variables_mapping {
        for environment_variable in environments.iter() {
            command.env(
                environment_variable.0.as_str(),
                environment_variable.1.as_str(),
            );
        }
    }

    let result = command.spawn().expect("Failed to spawn command").wait();
    if result.is_err() {
        print!("Command failed");
    }
}

pub fn get_command_output(command: &str) -> String {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();

    let mut binding = Command::new(primary_command);
    let command = binding.args(command_parts);

    let output = command.output().expect("Failed to execute command").stdout;
    String::from_utf8(output).unwrap()
}

pub fn format_runner_path(projects_root_path: String) -> String {
    let mut runner_path = projects_root_path;
    if env::var("HOME").is_ok() {
        let home_path = env::var("HOME").unwrap();
        if runner_path.starts_with(home_path.as_str()) {
            runner_path = runner_path.replace(home_path.as_str(), "~");
        }
    }
    runner_path
}

pub fn ensure_docker_network() {
    run_command("docker network create vfd-network", true, None);
}

pub fn self_update(settings: Settings) {
    let app_configs_path = settings.app_configs_path;
    println!("Running the self update procedure..");
    run_command(
        &format!("make -s -C {} self-update", app_configs_path),
        false,
        None,
    );
}

pub async fn print_service_infos(settings: Settings) {
    let host_services = traefik::fetch_trafik_hosts()
        .await
        .unwrap_or_else(|_| Vec::new());
    if !host_services.is_empty() {
        let current_services = settings.get_services();
        println!("Hosts:");
        for host_service in host_services {
            let service_folder_hint = host_service.1;
            let service_folder = current_services
                .iter()
                .find(|folder_service| service_folder_hint.ends_with(folder_service.as_str()));
            if let Some(service_folder) = service_folder {
                // Find out the docker-compose exposed host for the service
                let docker_compose_exposed_infos =
                    resolve_service_exposed_infos(&settings, service_folder.as_str());

                if !docker_compose_exposed_infos.is_empty() {
                    println!("> {}", host_service.0);
                    for exposed_info in docker_compose_exposed_infos {
                        println!(
                            "--> {}: http://localhost:{}",
                            exposed_info.0, exposed_info.1
                        );
                    }
                } else {
                    println!("> {}", host_service.0);
                }
            } else {
                println!("> {}", host_service.0);
            }
            println!(" ");
        }
    } else {
        println!("No traefik hosts found");
    }
}

pub fn print_build_info() {
    let version = env!("CARGO_PKG_VERSION");
    println!(
        "Version: {}, Architechture: {}",
        version,
        std::env::consts::ARCH
    );
}
