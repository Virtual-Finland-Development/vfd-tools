use crate::{CliArguments, Settings};
use anyhow::Result;
use std::process::{Command, Stdio};

pub struct Runner {
    args: CliArguments,
    settings: Settings,
}

impl Runner {
    pub fn new(args: CliArguments, settings: Settings) -> Self {
        Runner { args, settings }
    }

    pub fn run(&self) -> Result<()> {
        if self.args.test {
            println!("test");
            for profile in self.settings.profiles.iter() {
                println!("Running command for profile: {}", profile.name);
                for service in profile.services.iter() {
                    self.run_command(&format!(
                        "docker compose -f ../{}/docker-compose.yml ps",
                        service
                    ))?;
                }
            }
        }

        if self.args.fest {
            println!("fest");
            println!("{:?}", self.settings);
        }
        Ok(())
    }

    fn run_command(&self, command: &str) -> Result<()> {
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
}
