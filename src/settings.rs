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
    pub app_configs_path: String, // Populated at runtime
    #[serde(default)]
    pub has_service_selections: bool, // Populated at runtime
}

trait ResolveServices {
    fn get_services(&self) -> Vec<String>;
}

impl Settings {
    pub fn get_services(&self) -> Vec<String> {
        let mut services: Vec<String> = Vec::new();

        for profile in self.profiles.iter() {
            for service in profile.services.iter() {
                services.push(service.to_string());
            }
        }

        services
    }
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
    pub environment: Vec<DockerComposeEnvironment>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DockerComposeEnvironment {
    pub key: String,
    pub value: String,
    pub conditions: Option<Vec<DockerComposeCondition>>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DockerComposeCondition {
    pub key: String,
    pub value: String,
    pub operator: Option<DockerComposeConditionOperation>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum DockerComposeConditionOperation {
    #[serde(rename = "eq")]
    Eq,
    #[serde(rename = "neq")]
    Neq,
    #[serde(rename = "or")]
    Or,
    #[serde(rename = "xor")]
    Xor,
    #[serde(rename = "and")]
    And,
    #[serde(rename = "nand")]
    Nand,
}

fn read_settings() -> Settings {
    let app_configs_path = resolve_configurations_path();
    let settings_path = app_configs_path.join("settings.json");
    let setting_file_contents =
        fs::read_to_string(settings_path).expect("Failed to read settings.json");
    let mut settings: Settings = serde_json::from_str(setting_file_contents.as_str())
        .expect("Failed to parse settings.json");

    settings.app_configs_path = app_configs_path.to_str().unwrap().to_string();

    settings
}

fn resolve_configurations_path() -> PathBuf {
    if env::var("VFD_TOOLS_CONFIGS_PATH").is_ok() {
        return PathBuf::from(env::var("VFD_TOOLS_CONFIGS_PATH").unwrap());
    }

    let bin_exec_path = env::current_exe().expect("Failed to get current executable path");
    let app_configs_path = bin_exec_path
        .parent()
        .and_then(|parent| parent.parent())
        .and_then(|parent| parent.parent())
        .expect("Failed to get app root path");

    app_configs_path.to_path_buf()
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
        let mut app_configs_path = PathBuf::from(&settings.app_configs_path);
        app_configs_path.pop(); // ../
        settings.projects_root_path = app_configs_path.to_str().unwrap().to_string() + "/";
    }

    // Resolve other matters
    if env::var("VFD_SSH_GIT").is_ok() {
        settings.vfd_ssh_git = env::var("VFD_SSH_GIT").unwrap();
    }

    // Filter profiles
    let mut has_profile_filter = false;
    if let Some(profiles) = cli.profiles.as_deref() {
        has_profile_filter = true;
        settings.has_service_selections = true;
        settings
            .profiles
            .retain(|profile| profiles.contains(&profile.name));
    }

    // Filter services
    if let Some(services) = cli.services.as_deref() {
        settings.has_service_selections = true;
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
