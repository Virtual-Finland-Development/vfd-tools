use anyhow::Result;
use clap::{arg, command, CommandFactory, Parser, Subcommand};
use clap_complete::{generate, Shell};
use std::{ffi::OsString, io};

mod logs;

#[derive(Parser)]
#[command(name = "vfd")]
#[command(author = "lsipii@kapsi.fi")]
#[command(version = "1.0")]
#[command(about = "Engages in activities", long_about = None)]
pub struct CliArguments {
    // If provided, outputs the completion file for given shell
    #[arg(long = "generate-autocomplete", value_enum, hide = true)]
    pub generator: Option<Shell>,
    #[arg(long, short, value_parser = settings::get_possible_profile_names(), use_value_delimiter = true, global = true, hide_possible_values = true)]
    pub profiles: Option<Vec<String>>,
    #[arg(long, short, value_parser = settings::get_possible_service_names(), use_value_delimiter = true, global = true, hide_possible_values = true)]
    pub services: Option<Vec<String>>,
    #[arg(long, help = "Sets the working directory")]
    pub workdir: Option<String>,
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    #[command(visible_alias = "start")]
    Up {
        #[arg(long, help = "Skips the traefik domain routing")]
        no_traefik: bool,
        #[arg(long, help = "Runs the docker compose command without detaching")]
        no_detach: bool,
        #[arg(long, help = "Stop the use of internal state")]
        no_state: bool,
    },
    #[command(visible_alias = "stop")]
    Down {
        #[arg(long, help = "Skips the traefik domain routing")]
        no_traefik: bool,
        #[arg(long, help = "Stop the use of internal state")]
        no_state: bool,
    },
    #[command(visible_alias = "status")]
    Ps {
        #[arg(long, help = "Stop the use of internal state")]
        no_state: bool,
    },
    Restart {
        #[arg(long, help = "Stop the use of internal state")]
        no_state: bool,
    },
    Logs {
        #[arg(long, help = "Stop the use of internal state")]
        no_state: bool,
    },
    #[command(visible_alias = "hosts")]
    List {},
    #[command(about = "Run git command to the selection")]
    Git {
        #[command(subcommand)]
        command: GitCommands,
    },
    #[command(about = "Updates the vfd tool", visible_alias = "self-update")]
    Update {},
    #[command(about = "Prints the version")]
    Version {},
}

#[derive(Subcommand)]
enum GitCommands {
    Status {},
    Pull {},
    Push {},
    #[command(external_subcommand)]
    External(Vec<OsString>),
}

mod runner;
mod settings;

#[tokio::main]
async fn main() -> Result<()> {
    let cli = CliArguments::parse();

    // Shell auto-complete generator
    if let Some(generator) = cli.generator {
        let mut cmd = CliArguments::command();
        let name = cmd.get_name().to_string();
        generate(generator, &mut cmd, name, &mut io::stdout());
        return Ok(());
    }

    // Application logic
    let settings = settings::get_cli_settings(&cli);
    runner::run(&cli, settings).await
}
