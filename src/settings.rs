use serde_derive::{Deserialize, Serialize};
use std::{env, fs};

use crate::CliArguments;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Settings {
    #[serde(rename = "project-root-path")]
    #[serde(default)]
    pub project_root_path: String,
    pub profiles: Vec<Profile>,
    #[serde(rename = "vfd-ssh-git")]
    pub vfd_ssh_git: String,
}
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Profile {
    pub name: String,
    pub services: Vec<String>,
}

fn read_settings() -> Settings {
    // Read settings.json
    let setting_file_contents =
        fs::read_to_string("./settings.json").expect("Failed to read settings.json");
    let settings: Settings = serde_json::from_str(setting_file_contents.as_str())
        .expect("Failed to parse settings.json");

    settings
}

pub fn get_cli_settings(cli: &CliArguments) -> Settings {
    let mut settings = read_settings();

    // Resolve projects root path
    if env::var("VFD_PROJECTS_ROOT").is_ok() {
        settings.project_root_path = env::var("VFD_PROJECTS_ROOT").unwrap();
    }
    if cli.workdir.is_some() {
        settings.project_root_path = cli.workdir.clone().unwrap();
    }

    // If projects path is not set, use the parent directory of the vfd-tools project directory
    if settings.project_root_path.is_empty() {
        settings.project_root_path = std::env::current_dir()
            .unwrap()
            .to_str()
            .unwrap()
            .to_string()
            + "/../";
    }

    // Resolve other matters
    if env::var("VFD_SSH_GIT").is_ok() {
        settings.vfd_ssh_git = env::var("VFD_SSH_GIT").unwrap();
    }

    // Filter profiles
    let mut has_profile_filter = false;
    if let Some(profiles) = cli.profiles.as_deref() {
        has_profile_filter = true;
        let profiles_list = profiles.split(',').map(|s| s.trim()).collect::<Vec<&str>>();
        settings
            .profiles
            .retain(|profile| profiles_list.contains(&profile.name.as_str()));
    }

    // Filter services
    if let Some(services) = cli.services.as_deref() {
        let services_list = services.split(',').map(|s| s.trim()).collect::<Vec<&str>>();
        for profile in settings.profiles.iter_mut() {
            profile
                .services
                .retain(|service| services_list.contains(&service.as_str()));
        }
        settings
            .profiles
            .retain(|profile| !profile.services.is_empty());

        if !has_profile_filter {
            // Keep only the first profile for each service if no profile filter is set
            let mut services = vec![];
            for profile in settings.profiles.iter() {
                for service in profile.services.iter() {
                    if !services.contains(&service) {
                        services.push(service);
                    }
                }
            }
            settings.profiles = services
                .iter()
                .map(|service| Profile {
                    name: service.to_string(),
                    services: vec![service.to_string()],
                })
                .collect();
        }
    }

    settings
}

pub fn parse_profiles(s: &str) -> Result<String, String> {
    let settings = read_settings();
    let profiles = s.split(',').map(|s| s.trim()).collect::<Vec<&str>>();
    for profile in profiles {
        let mut found = false;
        for p in settings.profiles.iter() {
            if p.name == profile {
                found = true;
                break;
            }
        }
        if !found {
            return Err(format!("Profile {} not found", profile));
        }
    }
    Ok(s.to_string())
}

pub fn parse_services(s: &str) -> Result<String, String> {
    let settings = read_settings();
    let services = s.split(',').map(|s| s.trim()).collect::<Vec<&str>>();
    for service in services {
        let mut found = false;
        for profile in settings.profiles.iter() {
            if profile.services.contains(&service.to_string()) {
                found = true;
                break;
            }
        }
        if !found {
            return Err(format!("Service {} not found", service));
        }
    }
    Ok(s.to_string())
}
