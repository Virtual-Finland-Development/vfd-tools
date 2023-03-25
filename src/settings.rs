use serde_derive::{Deserialize, Serialize};
use std::{env, fs};

#[derive(Serialize, Deserialize, Debug)]
pub struct Settings {
    #[serde(rename = "project-root-path")]
    #[serde(default)]
    pub project_root_path: String,
    pub profiles: Vec<Profile>,
    #[serde(rename = "vfd-ssh-git")]
    pub vfd_ssh_git: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct Profile {
    pub name: String,
    pub services: Vec<String>,
}

pub fn get_settings() -> Settings {
    // Read settings.json
    let setting_file_contents =
        fs::read_to_string("./settings.json").expect("Failed to read settings.json");
    let mut settings: Settings = serde_json::from_str(setting_file_contents.as_str())
        .expect("Failed to parse settings.json");

    // Resolve projects root path
    if env::var("VFD_PROJECTS_ROOT").is_ok() {
        settings.project_root_path = env::var("VFD_PROJECTS_ROOT").unwrap();
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

    settings
}
