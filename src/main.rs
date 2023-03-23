// @draft: https://github.com/clap-rs/clap
use anyhow::Result;
use clap::Parser;

mod cli;
mod runner;

use cli::CliArguments;
use runner::Runner;

fn main() -> Result<()> {
    let args = CliArguments::parse();
    let runner = Runner::new(args);
    runner.run()
}
