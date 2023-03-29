use anyhow::Result;
use clap::{command, CommandFactory, Parser, Subcommand};
use clap_complete::{generate, Shell};
use std::io;

#[derive(Parser)]
#[command(name = "VFD-Tools")]
#[command(author = "lsipii@kapsi.fi")]
#[command(version = "1.0")]
#[command(about = "Engages in activities", long_about = None)]
pub struct CliArguments {
    // If provided, outputs the completion file for given shell
    #[arg(long = "generate", value_enum)]
    pub generator: Option<Shell>,
    #[arg(long, short)]
    pub profiles: Option<String>,
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    Up {},
    Down {},
    Ps {},
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
