use std::{
    env,
    process::{Command, Stdio},
};

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

pub fn format_runner_path(project_root_path: String) -> String {
    let mut runner_path = project_root_path;
    if env::var("HOME").is_ok() {
        let home_path = env::var("HOME").unwrap();
        if runner_path.starts_with(home_path.as_str()) {
            runner_path = runner_path.replace(home_path.as_str(), "~");
        }
    }
    if runner_path.contains("/../") {
        runner_path = runner_path.replace("/../", "/");
    }
    runner_path
}

pub fn ensure_docker_network() {
    run_command("docker network create vfd-network", true);
}
