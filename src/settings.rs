use serde_derive::{Deserialize, Serialize};
use std::fs;

#[derive(Serialize, Deserialize, Debug)]
pub struct Settings {
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
    let setting_file_contents =
        fs::read_to_string("./settings.json").expect("Failed to read settings.json");
    serde_json::from_str(setting_file_contents.as_str()).expect("Failed to parse settings.json")
}
