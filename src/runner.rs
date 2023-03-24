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
            let mut command_parts = "docker compose ps".split(' ');
            let primary_command = command_parts.next().unwrap();
            Command::new(primary_command)
                .args(command_parts)
                .stdout(Stdio::inherit())
                .spawn()
                .expect("Failed to execute docker compose");
        }

        if self.args.fest {
            println!("fest");
            println!("{:?}", self.settings);
        }
        Ok(())
    }
}
