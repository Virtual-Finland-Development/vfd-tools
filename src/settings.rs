use clap::builder::PossibleValue;
use serde_derive::{Deserialize, Serialize};
use std::{env, fs, path::PathBuf};

use crate::CliArguments;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Settings {
    #[serde(rename = "projects-root-path")]
    #[serde(default)]
    pub projects_root_path: String,
    pub profiles: Vec<Profile>,
    #[serde(rename = "dockerComposeOverrides")]
    pub docker_compose_overrides: DockerComposeOverrides,
    #[serde(rename = "vfd-ssh-git")]
    pub vfd_ssh_git: String,
    #[serde(default)]
    pub app_root_path: String, // Populated at runtime
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Profile {
    pub name: String,
    pub services: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DockerComposeOverrides {
    #[serde(rename = "alwaysRebuild")]
    pub always_rebuild: Vec<String>,
}

fn read_settings() -> Settings {
    // Read settings.json
    let bin_exec_path = env::current_exe().expect("Failed to get current executable path");
    let app_root_path = bin_exec_path
        .parent()
        .and_then(|parent| parent.parent())
        .and_then(|parent| parent.parent())
        .expect("Failed to get app root path");

    let settings_path = app_root_path.join("settings.json");
    let setting_file_contents =
        fs::read_to_string(settings_path).expect("Failed to read settings.json");
    let mut settings: Settings = serde_json::from_str(setting_file_contents.as_str())
        .expect("Failed to parse settings.json");

    settings.app_root_path = app_root_path.to_str().unwrap().to_string();

    settings
}

pub fn get_cli_settings(cli: &CliArguments) -> Settings {
    let mut settings = read_settings();

    // Resolve projects root path
    if env::var("VFD_PROJECTS_ROOT").is_ok() {
        settings.projects_root_path = env::var("VFD_PROJECTS_ROOT").unwrap();
    }
    if cli.workdir.is_some() {
        settings.projects_root_path = cli.workdir.clone().unwrap();
    }

    // If projects path is not set, use the parent directory of the vfd-tools project directory
    if settings.projects_root_path.is_empty() {
        let mut app_root_path = PathBuf::from(&settings.app_root_path);
        app_root_path.pop(); // ../
        settings.projects_root_path = app_root_path.to_str().unwrap().to_string() + "/";
    }

    // Resolve other matters
    if env::var("VFD_SSH_GIT").is_ok() {
        settings.vfd_ssh_git = env::var("VFD_SSH_GIT").unwrap();
    }

    // Filter profiles
    let mut has_profile_filter = false;
    if let Some(profiles) = cli.profiles.as_deref() {
        has_profile_filter = true;
        settings
            .profiles
            .retain(|profile| profiles.contains(&profile.name));
    }

    // Filter services
    if let Some(services) = cli.services.as_deref() {
        for profile in settings.profiles.iter_mut() {
            profile
                .services
                .retain(|service| services.contains(service));
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
                    name: String::from(""),
                    services: vec![service.to_string()],
                })
                .collect();
        }
    }

    settings
}

pub fn get_possible_profile_names() -> Vec<PossibleValue> {
    let settings = read_settings();

    settings
        .profiles
        .iter()
        .map(|profile| PossibleValue::new(profile.name.clone()))
        .collect()
}

pub fn get_possible_service_names() -> Vec<PossibleValue> {
    let settings = read_settings();

    let mut services = vec![];
    for profile in settings.profiles.iter() {
        for service in profile.services.iter() {
            if !services.contains(&service) {
                services.push(service);
            }
        }
    }

    services
        .iter()
        .map(|service| PossibleValue::new(&(*service).clone()))
        .collect()
}
