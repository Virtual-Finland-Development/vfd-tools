use crate::{settings::Settings, CliArguments, Commands, GitCommands};
use anyhow::Result;
mod utils;

pub async fn run(cli: &CliArguments, settings: Settings) -> Result<()> {
    match &cli.command {
        Some(Commands::Up {}) => {
            docker_compose::run_docker_compose_services_loop("up -d", &settings).await;
        }
        Some(Commands::Down {}) => {
            docker_compose::run_docker_compose_services_loop("down", &settings).await;
        }
        Some(Commands::Ps {}) => {
            docker_compose::run_docker_compose_services_loop("ps", &settings).await;
        }
        Some(Commands::Restart {}) => {
            docker_compose::run_docker_compose_services_loop("restart", &settings).await;
        }
        Some(Commands::Logs {}) => {
            docker_compose::run_docker_compose_services_loop("logs --tail=20", &settings).await;
        }
        Some(Commands::List {}) => {
            utils::print_traefik_hosts_info().await;
        }
        Some(Commands::Git {
            command: GitCommands::Status {},
        }) => {
            git::run_git_command_loop("status", &settings).await;
        }
        Some(Commands::Git {
            command: GitCommands::Pull {},
        }) => {
            git::run_git_command_loop("pull", &settings).await;
        }
        Some(Commands::Git {
            command: GitCommands::Push {},
        }) => {
            git::run_git_command_loop("push", &settings).await;
        }
        Some(Commands::Git {
            command: GitCommands::Commit { message },
        }) => {
            let message = match message {
                Some(message) => message,
                None => {
                    println!("Please provide a commit message");
                    return Ok(());
                }
            };
            git::run_git_command_loop(&format!("commit -m \"{}\"", message), &settings).await;
        }
        None => {}
    }
    Ok(())
}

mod git {
    use crate::settings::Settings;

    use super::utils;

    pub async fn run_git_command_loop(git_command: &str, settings: &Settings) {
        for profile in settings.profiles.iter() {
            println!("----- Profile: {} ...", profile.name);
            let services = &profile.services;
            for service in services.iter() {
                run_git_command(service, git_command, settings);
            }
        }
    }

    pub fn run_git_command(service: &str, git_command: &str, settings: &Settings) {
        let project_root_path = settings.project_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(project_root_path.clone());

        println!("> {}git:\ngit {}", formatted_runner_path, git_command);
        utils::run_command(
            &format!("git -C {}/{} {}", project_root_path, service, git_command),
            false,
        );
    }
}

mod docker_compose {
    use crate::settings::Settings;

    use super::utils;

    pub async fn run_docker_compose_services_loop(
        docker_compose_command: &str,
        settings: &Settings,
    ) {
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

    fn run_docker_compose_command(
        service: &str,
        docker_compose_command: &str,
        settings: &Settings,
    ) {
        let project_root_path = settings.project_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(project_root_path.clone());

        println!(
            "> {}{}:\ndocker compose {}",
            formatted_runner_path, service, docker_compose_command
        );
        utils::run_command(
            &format!(
                "docker compose -f {}/{}/docker-compose.yml {}",
                project_root_path, service, docker_compose_command
            ),
            false,
        );
    }
}
