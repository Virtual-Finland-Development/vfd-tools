use crate::{settings::Settings, CliArguments, Commands, GitCommands};
use anyhow::Result;
mod commander;
mod runner_app;
mod state;
mod traefik;

use self::commander::{Command, Commander};

pub async fn run(cli: &CliArguments, settings: Settings) -> Result<()> {
    let mut commander = Commander::new(settings.clone());

    match &cli.command {
        Some(Commands::Up {
            no_detach,
            no_traefik,
            no_state,
        }) => {
            runner_app::ensure_docker_network();

            if !*no_state {
                let previous_state_settings = state::read(settings.clone());
                if let Some(previous_state_settings) = previous_state_settings {
                    let merged_settings = merge_settings(settings.clone(), previous_state_settings);
                    state::store(merged_settings);
                } else {
                    state::store(settings.clone());
                }
            }

            if !*no_traefik {
                traefik::start_traefik(settings.clone());
            }

            if *no_detach {
                commander.run("docker-compose", "up");
            } else {
                commander.run("docker-compose", "up -d");
            }
        }
        Some(Commands::Down {
            no_traefik,
            no_state,
        }) => {
            if !*no_state {
                override_state_with_previous_if_none_set(settings.clone(), &mut commander, true);
            }
            commander.run("docker-compose", "down");

            if !*no_traefik {
                traefik::stop_traefik(settings.clone());
            }
        }
        Some(Commands::Ps { no_state }) => {
            if !*no_state {
                override_state_with_previous_if_none_set(settings.clone(), &mut commander, false);
            }
            commander.run("docker-compose", "ps");
        }
        Some(Commands::Restart { no_state }) => {
            if !*no_state {
                override_state_with_previous_if_none_set(settings.clone(), &mut commander, false);
            }
            commander.run("docker-compose", "restart");
        }
        Some(Commands::Logs { no_state }) => {
            if !*no_state {
                override_state_with_previous_if_none_set(settings.clone(), &mut commander, false);
            }
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
            command: GitCommands::Clone {},
        }) => {
            commander.run("git", "clone");
        }
        Some(Commands::Git {
            command: GitCommands::External(args),
        }) => {
            let args = args
                .iter()
                .map(|arg| arg.to_str().unwrap())
                .collect::<Vec<&str>>();
            commander.run("git", &args.join(" "));
        }
        Some(Commands::Update {}) => {
            runner_app::self_update(settings.clone());
        }
        Some(Commands::BuildInfo {}) => {
            runner_app::print_build_info();
        }
        None => {}
    }
    Ok(())
}

/**
 * Load previous state if no service selections
 */
fn override_state_with_previous_if_none_set(
    settings: Settings,
    commander: &mut Commander,
    flush: bool,
) {
    // Load state if no service selections
    if flush {
        if !settings.has_service_selections {
            let state_settings = state::flush(settings);
            if let Some(state_settings) = state_settings {
                commander.set_settings(state_settings);
            }
        } else {
            state::clear(settings);
        }
    } else if !settings.has_service_selections {
        let state_settings = state::read(settings);
        if let Some(state_settings) = state_settings {
            commander.set_settings(state_settings);
        }
    }
}

fn merge_settings(settings: Settings, previous_state_settings: Settings) -> Settings {
    let mut merged_settings = settings;
    // Append previous state profiles and services to the current one
    for previous_profile in previous_state_settings.profiles {
        let current_profile = merged_settings
            .profiles
            .iter_mut()
            .find(|p| p.name == previous_profile.name);

        if let Some(current_profile) = current_profile {
            let mut current_services = current_profile.services.clone();
            let previous_profile_services = previous_profile.services.clone();
            for previous_profile_service_name in previous_profile_services {
                if !current_services.contains(&previous_profile_service_name) {
                    current_services.push(previous_profile_service_name);
                }
            }
        } else {
            merged_settings.profiles.push(previous_profile);
        }
    }
    merged_settings
}
