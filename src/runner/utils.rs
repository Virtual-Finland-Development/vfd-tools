use anyhow::Result;
use std::{
    env,
    process::{Command, Stdio},
};

pub fn run_command(command: &str) -> Result<()> {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();
    Command::new(primary_command)
        .args(command_parts)
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .spawn()?
        .wait()?;
    Ok(())
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
