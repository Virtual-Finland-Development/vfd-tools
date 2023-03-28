use crate::{settings::Settings, CliArguments};
use anyhow::Result;
mod utils;

pub async fn run(args: CliArguments, settings: Settings) -> Result<()> {
    if args.test {
        println!("test");
        let project_root_path = settings.project_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(project_root_path.clone());
        for profile in settings.profiles.iter() {
            println!("----- Profile: {} ...", profile.name);
            for service in profile.services.iter() {
                println!("> {}{}:\ndocker compose ps", formatted_runner_path, service);
                utils::run_command(
                    &format!(
                        "docker compose -f {}/{}/docker-compose.yml ps",
                        project_root_path, service
                    ),
                    false,
                )?;
            }
        }
    }

    if args.fest {
        utils::ensure_docker_network();
        utils::print_traefik_hosts_info().await;
    }
    Ok(())
}
