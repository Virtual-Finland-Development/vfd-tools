use anyhow::Result;
use clap::{arg, command, CommandFactory, Parser, Subcommand};
use clap_complete::{generate, Shell};
use std::io;

#[derive(Parser)]
#[command(name = "vfd")]
#[command(author = "lsipii@kapsi.fi")]
#[command(version = "1.0")]
#[command(about = "Engages in activities", long_about = None)]
pub struct CliArguments {
    // If provided, outputs the completion file for given shell
    #[arg(long = "generate-autocomplete", value_enum, hide = true)]
    pub generator: Option<Shell>,
    #[arg(long, short, value_parser = settings::parse_profiles)]
    pub profiles: Option<String>,
    #[arg(long, short, value_parser = settings::parse_services)]
    pub services: Option<String>,
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
    },
    #[command(visible_alias = "stop")]
    Down {
        #[arg(long, help = "Skips the traefik domain routing")]
        no_traefik: bool,
    },
    #[command(visible_alias = "status")]
    Ps {},
    Restart {},
    Logs {},
    #[command(visible_alias = "list-hosts")]
    List {},
    #[command(about = "Runs a git commandline command")]
    Git {
        #[command(subcommand)]
        command: GitCommands,
    },
}

#[derive(Subcommand)]
enum GitCommands {
    Status {},
    Pull {},
    Push {},
    Commit {
        #[arg(long, short)]
        message: Option<String>,
    },
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
