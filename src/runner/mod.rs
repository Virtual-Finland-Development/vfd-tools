use crate::{settings::Settings, CliArguments, Commands, GitCommands};
use anyhow::Result;
mod utils;

pub async fn run(cli: &CliArguments, settings: Settings) -> Result<()> {
    match &cli.command {
        Some(Commands::Up {}) => {
            utils::ensure_docker_network();
            DockerCompose::new(settings).run("up -d");
            utils::print_traefik_hosts_info().await;
        }
        Some(Commands::Down {}) => {
            DockerCompose::new(settings).run("down");
        }
        Some(Commands::Ps {}) => {
            DockerCompose::new(settings).run("ps");
        }
        Some(Commands::Restart {}) => {
            DockerCompose::new(settings).run("restart");
        }
        Some(Commands::Logs {}) => {
            DockerCompose::new(settings).run("logs --tail=20");
        }
        Some(Commands::List {}) => {
            utils::print_traefik_hosts_info().await;
        }
        Some(Commands::Git {
            command: GitCommands::Status {},
        }) => {
            Git::new(settings).run("status");
        }
        Some(Commands::Git {
            command: GitCommands::Pull {},
        }) => {
            Git::new(settings).run("pull");
        }
        Some(Commands::Git {
            command: GitCommands::Push {},
        }) => {
            Git::new(settings).run("push");
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
            Git::new(settings).run(&format!("commit -m \"{}\"", message));
        }
        None => {}
    }
    Ok(())
}

trait LoopCommand {
    fn new(settings: Settings) -> Self;
    fn run(&self, command: &str);
    fn run_command(&self, service: &str, command: &str);
}

struct DockerCompose {
    settings: Settings,
}
impl LoopCommand for DockerCompose {
    fn new(settings: Settings) -> Self {
        Self { settings }
    }

    fn run(&self, command: &str) {
        for profile in self.settings.profiles.iter() {
            println!("----- Profile: {} ...", profile.name);
            let services = &profile.services;
            for service in services.iter() {
                self.run_command(service, command);
            }
        }
    }

    fn run_command(&self, service: &str, command: &str) {
        let project_root_path = self.settings.project_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(project_root_path.clone());

        println!(
            "> {}{}:\ndocker compose {}",
            formatted_runner_path, service, command
        );
        utils::run_command(
            &format!(
                "docker compose -f {}/{}/docker-compose.yml {}",
                project_root_path, service, command
            ),
            false,
        );
    }
}

struct Git {
    settings: Settings,
}
impl LoopCommand for Git {
    fn new(settings: Settings) -> Self {
        Self { settings }
    }

    fn run(&self, command: &str) {
        for profile in self.settings.profiles.iter() {
            println!("----- Profile: {} ...", profile.name);
            let services = &profile.services;
            for service in services.iter() {
                self.run_command(service, command);
            }
        }
    }

    fn run_command(&self, service: &str, command: &str) {
        let project_root_path = self.settings.project_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(project_root_path.clone());

        println!("> {}git:\ngit {}", formatted_runner_path, command);
        utils::run_command(
            &format!("git -C {}/{} {}", project_root_path, service, command),
            false,
        );
    }
}
