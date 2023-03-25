use crate::{settings::Settings, CliArguments};
use anyhow::Result;
use std::process::{Command, Stdio};

pub fn run(args: CliArguments, settings: Settings) -> Result<()> {
    if args.test {
        println!("test");
        for profile in settings.profiles.iter() {
            println!("Running command for profile: {}", profile.name);
            for service in profile.services.iter() {
                run_command(&format!(
                    "docker compose -f ../{}/docker-compose.yml ps",
                    service
                ))?;
            }
        }
    }

    if args.fest {
        println!("fest");
        println!("{:?}", settings);
    }
    Ok(())
}

fn run_command(command: &str) -> Result<()> {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();
    Command::new(primary_command)
        .args(command_parts)
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .spawn()?
        .wait()?;
    Ok(())
}
