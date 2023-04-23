use std::fs;

use serde_json::{from_str, json};

use crate::{logs::log_heading, settings::Settings};

pub fn store(settings: Settings) {
    let binding = json!(settings).to_string();
    let state = binding.as_str();
    run_state_operation(settings, "store", state);
}

pub fn read(settings: Settings) -> Option<Settings> {
    run_state_operation(settings, "read", "")
}

pub fn flush(settings: Settings) -> Option<Settings> {
    run_state_operation(settings, "flush", "")
}

pub fn clear(settings: Settings) {
    run_state_operation(settings, "clear", "");
}

fn run_state_operation(settings: Settings, operation: &str, params: &str) -> Option<Settings> {
    log_heading("vfd-tools state: ".to_owned() + operation);
    let app_configs_path = &settings.app_configs_path;
    let state_path = format!("{}/.state", app_configs_path);
    let state_file_path = format!("{}/.state", state_path);

    // Ensure state directory exists
    fs::create_dir_all(state_path).unwrap_or_default();

    // Read-write operations match
    let mut contents = String::new();
    match operation {
        "store" => {
            fs::write(state_file_path, params).unwrap_or_default();
        }
        "read" => {
            contents = fs::read_to_string(state_file_path).unwrap_or_default();
        }
        "flush" => {
            contents = fs::read_to_string(&state_file_path).unwrap_or_default();
            fs::remove_file(state_file_path).unwrap_or_default();
        }
        "clear" => {
            fs::remove_file(state_file_path).unwrap_or_default();
        }
        _ => {}
    }
    if let Ok(settings) = from_str::<Settings>(&contents) {
        Some(settings)
    } else {
        None
    }
}
