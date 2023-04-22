use serde_json::{from_str, json};

use crate::{logs::log_heading, settings::Settings};

use super::runner_app::get_command_output;

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
    log_heading("VFD-Tools State: ".to_owned() + operation);
    let app_configs_path = &settings.app_configs_path;
    // Read state
    let contents = get_command_output(&format!(
        "docker compose -f {}/docker-compose.state.yml run --rm vfd-tools-state {} {}",
        app_configs_path, operation, params
    ));

    if let Ok(settings) = from_str::<Settings>(&contents) {
        Some(settings)
    } else {
        None
    }
}
