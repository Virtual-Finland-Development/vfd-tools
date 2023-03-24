use anyhow::Result;
use clap::{command, CommandFactory, Parser};
use clap_complete::{generate, Shell};
use serde_derive::{Deserialize, Serialize};
use std::{fs, io};

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

#[derive(Serialize, Deserialize, Debug)]
pub struct Settings {
    pub profiles: Vec<Profile>,
    #[serde(rename = "vfd-ssh-git")]
    pub vfd_ssh_git: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct Profile {
    name: String,
    services: Vec<String>,
}

mod runner;

fn main() -> Result<()> {
    let args = CliArguments::parse();

    if let Some(generator) = args.generator {
        let mut cmd = CliArguments::command();
        let name = cmd.get_name().to_string();
        generate(generator, &mut cmd, name, &mut io::stdout());
        return Ok(());
    }

    let setting_file_contents =
        fs::read_to_string("./settings.json").expect("Failed to read settings.json");
    let settings: Settings = serde_json::from_str(setting_file_contents.as_str())?;

    runner::Runner::new(args, settings).run()
}
