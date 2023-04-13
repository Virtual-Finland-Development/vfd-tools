use crate::{runner::utils, settings::Settings};

pub trait Command {
    fn new(settings: Settings) -> Self;
    fn run(&self, action: &str, command: &str);
    fn run_specific_action(&self, action: &str, service: &str, command: &str);
    fn run_docker_compose_action(&self, service: &str, command: &str);
    fn run_git_action(&self, service: &str, command: &str);
}

pub struct Commander {
    pub settings: Settings,
}

impl Command for Commander {
    fn new(settings: Settings) -> Self {
        Commander { settings }
    }

    fn run(&self, action: &str, command: &str) {
        for profile in self.settings.profiles.iter() {
            println!("----- Profile: {} ...", profile.name);
            let services = &profile.services;
            for service in services.iter() {
                self.run_specific_action(action, service, command);
            }
        }
    }

    fn run_specific_action(&self, action: &str, service: &str, command: &str) {
        match action {
            "docker-compose" => self.run_docker_compose_action(service, command),
            "git" => self.run_git_action(service, command),
            _ => {
                panic!("Unknown action: {}", action);
            }
        }
    }

    fn run_docker_compose_action(&self, service: &str, command: &str) {
        let projects_root_path = self.settings.projects_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(projects_root_path.clone());

        println!(
            "> {}{} → docker compose {}",
            formatted_runner_path, service, command
        );
        utils::run_command(
            &format!(
                "docker compose -f {}/{}/docker-compose.yml {}",
                projects_root_path, service, command
            ),
            false,
        );
    }

    fn run_git_action(&self, service: &str, command: &str) {
        let projects_root_path = self.settings.projects_root_path.clone();
        let formatted_runner_path = utils::format_runner_path(projects_root_path.clone());

        println!("> {} → git {}", formatted_runner_path, command);
        utils::run_command(
            &format!("git -C {}/{} {}", projects_root_path, service, command),
            false,
        );
    }
}
