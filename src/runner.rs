use super::CliArguments;
use anyhow::Result;
use clap::{Command as ClapCommand, CommandFactory};
use clap_complete::{generate, Generator};
use std::io;
use std::process::{Command, Stdio};

fn print_completions<G: Generator>(gen: G, cmd: &mut ClapCommand) {
    generate(gen, cmd, cmd.get_name().to_string(), &mut io::stdout());
}

pub struct Runner {
    args: CliArguments,
}

impl Runner {
    pub fn new(args: CliArguments) -> Self {
        Runner { args }
    }

    pub fn run(&self) -> Result<()> {
        if let Some(generator) = self.args.generator {
            let mut cmd = CliArguments::command();
            print_completions(generator, &mut cmd);
            return Ok(());
        }

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
        }
        Ok(())
    }
}
