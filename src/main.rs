// @draft: https://github.com/clap-rs/clap
use anyhow::Result;
use clap::{command, Parser};
use clap_complete::Shell;

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

fn main() -> Result<()> {
    let args = CliArguments::parse();
    runner::Runner::new(args).run()
}
