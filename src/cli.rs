use clap::{command, Parser};

#[derive(Parser)]
#[command(name = "VFD-Tools")]
#[command(author = "lsipii@kapsi.fi")]
#[command(version = "1.0")]
#[command(about = "Engages in activities", long_about = None)]
pub struct CliArguments {
    #[arg(long, short)]
    pub test: bool,
    #[arg(long, short)]
    pub fest: bool,
}
