use std::{
    env,
    process::{Command, Stdio},
};

use crate::settings::Settings;

pub fn run_command(command: &str, quiet: bool) {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();

    let mut binding = Command::new(primary_command);
    let command = binding.args(command_parts);

    if quiet {
        command.stdout(Stdio::null()).stderr(Stdio::null());
    } else {
        command.stdout(Stdio::inherit()).stderr(Stdio::inherit());
    }

    let result = command.spawn().expect("Failed to spawn command").wait();
    if result.is_err() {
        print!("Command failed");
    }
}

pub fn format_runner_path(projects_root_path: String) -> String {
    let mut runner_path = projects_root_path;
    if env::var("HOME").is_ok() {
        let home_path = env::var("HOME").unwrap();
        if runner_path.starts_with(home_path.as_str()) {
            runner_path = runner_path.replace(home_path.as_str(), "~");
        }
    }
    runner_path
}

pub fn ensure_docker_network() {
    run_command("docker network create vfd-network", true);
}

pub fn self_update(settings: Settings) {
    let app_root_path = settings.app_root_path;
    println!("Running the self update procedure..");
    println!("> Updating with git..");
    run_command(&format!("git -C {} pull", app_root_path), false);
    println!("> Rebuilding..");
    run_command(&format!("make -C {} build", app_root_path), false);
}
