use anyhow::Result;
use clap::{arg, command, CommandFactory, Parser, Subcommand};
use clap_complete::{generate, Shell};
use std::io;

#[derive(Parser)]
#[command(name = "VFD-Tools")]
#[command(author = "lsipii@kapsi.fi")]
#[command(version = "1.0")]
#[command(about = "Engages in activities", long_about = None)]
pub struct CliArguments {
    // If provided, outputs the completion file for given shell
    #[arg(long = "generate", value_enum, hide = true)]
    pub generator: Option<Shell>,
    #[arg(long, short)]
    pub profiles: Option<String>,
    #[arg(long, short)]
    pub services: Option<String>,
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    #[command(visible_alias = "start")]
    Up {},
    #[command(visible_alias = "stop")]
    Down {},
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
    let settings = settings::get_settings(&cli);
    runner::run(&cli, settings).await
}
