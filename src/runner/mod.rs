use crate::{settings::Settings, CliArguments, Commands, GitCommands};
use anyhow::Result;
mod commander;
mod runner_app;
mod traefik;

use self::commander::{Command, Commander};

pub async fn run(cli: &CliArguments, settings: Settings) -> Result<()> {
    let commander = Commander::new(settings.clone());

    match &cli.command {
        Some(Commands::Up {
            no_detach,
            no_traefik,
        }) => {
            runner_app::ensure_docker_network();

            if !*no_traefik {
                traefik::start_traefik(settings.clone());
            }

            if *no_detach {
                commander.run("docker-compose", "up");
            } else {
                commander.run("docker-compose", "up -d");
            }
        }
        Some(Commands::Down { no_traefik }) => {
            commander.run("docker-compose", "down");

            if !*no_traefik {
                traefik::stop_traefik(settings.clone());
            }
        }
        Some(Commands::Ps {}) => {
            commander.run("docker-compose", "ps");
        }
        Some(Commands::Restart {}) => {
            commander.run("docker-compose", "restart");
        }
        Some(Commands::Logs {}) => {
            commander.run("docker-compose", "logs --tail=20");
        }
        Some(Commands::List {}) => {
            runner_app::print_service_infos(settings.clone()).await;
        }
        Some(Commands::Git {
            command: GitCommands::Status {},
        }) => {
            commander.run("git", "status");
        }
        Some(Commands::Git {
            command: GitCommands::Pull {},
        }) => {
            commander.run("git", "pull");
        }
        Some(Commands::Git {
            command: GitCommands::Push {},
        }) => {
            commander.run("git", "push");
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
            commander.run("git", &format!("commit -m \"{}\"", message));
        }
        Some(Commands::Update {}) => {
            runner_app::self_update(settings.clone());
        }
        None => {}
    }
    Ok(())
}
