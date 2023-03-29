use crate::{settings::Settings, CliArguments, Commands};
use anyhow::Result;
mod utils;

pub async fn run(cli: &CliArguments, settings: Settings) -> Result<()> {
    match cli.command {
        Some(Commands::Up {}) => {
            run_docker_compose_services_loop("up -d", &settings).await;
        }
        Some(Commands::Down {}) => {
            run_docker_compose_services_loop("down", &settings).await;
        }
        Some(Commands::Ps {}) => {
            run_docker_compose_services_loop("ps", &settings).await;
        }
        None => {}
    }
    Ok(())
}

async fn run_docker_compose_services_loop(docker_compose_command: &str, settings: &Settings) {
    utils::ensure_docker_network();

    for profile in settings.profiles.iter() {
        println!("----- Profile: {} ...", profile.name);
        let services = &profile.services;
        for service in services.iter() {
            run_docker_compose_command(service, docker_compose_command, settings);
        }
    }

    utils::print_traefik_hosts_info().await
}

fn run_docker_compose_command(service: &str, docker_compose_command: &str, settings: &Settings) {
    let project_root_path = settings.project_root_path.clone();
    let formatted_runner_path = utils::format_runner_path(project_root_path.clone());

    println!("> {}{}:\ndocker compose ps", formatted_runner_path, service);
    utils::run_command(
        &format!(
            "docker compose -f {}/{}/docker-compose.yml {}",
            project_root_path, service, docker_compose_command
        ),
        false,
    );
}
