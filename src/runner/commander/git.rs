use crate::{runner::runner_app, settings::Settings};

pub fn run_action(settings: &Settings, service: &str, command: &str) {
    let projects_root_path = settings.projects_root_path.clone();
    let formatted_runner_path = runner_app::format_runner_path(projects_root_path.clone());

    println!("> {}/{} → git {}", formatted_runner_path, service, command);
    runner_app::run_command(
        &format!("git -C {}/{} {}", projects_root_path, service, command),
        false,
    );
}
