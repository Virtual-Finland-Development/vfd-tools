use std::env;

use crate::{logs::log_heading, settings::Settings};

use super::runner_app::run_command;
use anyhow::Result;

pub fn start_traefik(settings: Settings) {
    if is_traefik_globally_disabled() {
        return;
    }

    log_heading("Traefik");
    let app_configs_path = settings.app_configs_path;
    run_command(
        &format!(
            "docker compose -f {}/docker-compose.traefik.yml up -d",
            app_configs_path
        ),
        false,
    );
}

pub fn stop_traefik(settings: Settings) {
    if is_traefik_globally_disabled() {
        return;
    }

    log_heading("Traefik");
    let app_configs_path = settings.app_configs_path;
    run_command(
        &format!(
            "docker compose -f {}/docker-compose.traefik.yml down",
            app_configs_path
        ),
        false,
    );
}

fn is_traefik_globally_disabled() -> bool {
    env::var("VFD_USE_TRAEFIK").is_ok() && env::var("VFD_USE_TRAEFIK").unwrap() == "false"
}

pub async fn fetch_trafik_hosts() -> Result<Vec<(String, String)>> {
    let response = reqwest::get("http://localhost:8081/api/rawdata").await?;
    let response_body = response.text().await?;
    let hosts_info = serde_json::from_str::<serde_json::Value>(&response_body)?;

    let mut hosts: Vec<String> = Vec::new();
    let mut host_services: Vec<String> = Vec::new();

    let routers = hosts_info["routers"].as_object().unwrap();
    let services = hosts_info["services"].as_object().unwrap();

    for (_router_key, router) in routers {
        let rule = router["rule"].as_str().unwrap();
        if rule.contains("Host(") {
            let host = rule.replace("Host(`", "").replace("`)", "");
            let service_name = router["service"].as_str().unwrap();
            let service_name_key = format!("{}@docker", service_name);

            if host.contains("traefik") || !services.contains_key(&service_name_key) {
                if !services.contains_key(&service_name_key) {
                    println!("DEBUG: Service not found: {}", &service_name_key);
                }
                continue;
            }

            let http_host = format!("http://{}", host);
            if !hosts.contains(&http_host) {
                hosts.push(http_host);
                host_services.push(service_name.to_owned());
            }
        }
    }

    let mut hosts_with_services: Vec<(String, String)> = Vec::new();
    for (index, host) in hosts.iter().enumerate() {
        hosts_with_services.push((host.to_owned(), host_services[index].to_owned()));
    }

    Ok(hosts_with_services)
}
