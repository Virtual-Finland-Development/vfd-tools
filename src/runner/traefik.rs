use std::env;

use crate::{logs::log_heading, settings::Settings};

use super::utils::run_command;
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

pub async fn print_traefik_hosts_info() {
    async fn fetch_info() -> Result<Vec<String>> {
        let response = reqwest::get("http://localhost:8081/api/rawdata").await?;
        let response_body = response.text().await?;
        let hosts_info = serde_json::from_str::<serde_json::Value>(&response_body)?;
        let mut hosts = Vec::new();
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

                let service = services[&service_name_key]
                    .as_object()
                    .expect("Failed to parse service");
                let load_balancer = service["loadBalancer"]
                    .as_object()
                    .expect("Failed to parse service load balancer");
                let servers = load_balancer["servers"]
                    .as_array()
                    .expect("Failed to parse service servers");
                let server = servers[0]["url"]
                    .as_str()
                    .expect("Failed to parse service server");

                let server_host_parts = server.split(':').collect::<Vec<&str>>();
                if server_host_parts.len() != 3 {
                    panic!("Failed to parse server host: {}", server)
                }

                let server_port = server_host_parts[2];
                let host_server_combo =
                    format!("http://{} -> http://localhost:{}", host, server_port);
                if !hosts.contains(&host_server_combo) {
                    hosts.push(host_server_combo);
                }
            }
        }

        Ok(hosts)
    }

    let hosts = fetch_info().await.unwrap_or_else(|_| Vec::new());
    if !hosts.is_empty() {
        println!("Hosts:");
        for host in hosts {
            println!("> {}", host);
        }
    } else {
        println!("No traefik hosts found");
    }
}
