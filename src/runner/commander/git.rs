use crate::{runner::utils, settings::Settings};

pub fn run_action(settings: &Settings, service: &str, command: &str) {
    let projects_root_path = settings.projects_root_path.clone();
    let formatted_runner_path = utils::format_runner_path(projects_root_path.clone());

    println!("> {}/{} → git {}", formatted_runner_path, service, command);
    utils::run_command(
        &format!("git -C {}/{} {}", projects_root_path, service, command),
        false,
    );
}
