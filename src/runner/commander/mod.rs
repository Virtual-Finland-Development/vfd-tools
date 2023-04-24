use crate::{logs::log_heading, settings::Settings};

pub(crate) mod docker_compose;
mod git;

pub trait Command {
    fn new(settings: Settings) -> Self;
    fn run(&self, action: &str, command: &str);
    fn run_specific_action(&self, action: &str, service: &str, command: &str);
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
            let is_profile_target = !profile.name.is_empty();
            if is_profile_target {
                log_heading(format!("Profile: {}", profile.name));
            }

            let services = &profile.services;
            for service in services.iter() {
                if !is_profile_target {
                    log_heading(format!("Service: {}", service));
                }
                self.run_specific_action(action, service, command);
            }
        }
    }

    fn run_specific_action(&self, action: &str, service: &str, command: &str) {
        match action {
            "docker-compose" => docker_compose::run_action(&self.settings, service, command),
            "git" => git::run_action(&self.settings, service, command),
            _ => {
                panic!("Unknown action: {}", action);
            }
        }
    }
}
