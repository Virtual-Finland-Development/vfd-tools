use crate::{runner::utils, settings::Settings};

pub fn run_action(settings: &Settings, service: &str, command: &str) {
    let projects_root_path = settings.projects_root_path.clone();
    let formatted_runner_path = utils::format_runner_path(projects_root_path.clone());
    let mut command_actual = command.to_string();

    if command.starts_with("up")
        && settings
            .docker_compose_overrides
            .always_rebuild
            .contains(&service.to_string())
        && !command.contains("--build")
    {
        command_actual = format!("{} --build", command);
    }

    println!(
        "> {}{} → docker compose {}",
        formatted_runner_path, service, command_actual
    );
    utils::run_command(
        &format!(
            "docker compose -f {}/{}/docker-compose.yml {}",
            projects_root_path, service, command_actual
        ),
        false,
    );
}
