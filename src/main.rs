use anyhow::Result;
use clap::{command, CommandFactory, Parser};
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
    pub test: bool,
    #[arg(long, short)]
    pub fest: bool,
}

mod runner;
mod settings;

fn main() -> Result<()> {
    let args = CliArguments::parse();

    if let Some(generator) = args.generator {
        let mut cmd = CliArguments::command();
        let name = cmd.get_name().to_string();
        generate(generator, &mut cmd, name, &mut io::stdout());
        return Ok(());
    }

    let settings = settings::get_settings();
    runner::Runner::new(args, settings).run()
}
