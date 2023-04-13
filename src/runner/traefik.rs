use std::env;

use super::utils::run_command;
use anyhow::Result;

pub fn start_traefik() {
    if is_traefik_globally_disabled() {
        return;
    }
    run_command("docker compose -f docker-compose.traefik.yml up -d", false);
}

pub fn stop_traefik() {
    if is_traefik_globally_disabled() {
        return;
    }
    run_command("docker compose -f docker-compose.traefik.yml down", false);
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

        for (service_name, router) in routers {
            let rule = router["rule"].as_str().unwrap();
            if rule.contains("Host(") {
                let host = rule.replace("Host(`", "").replace("`)", "");

                if host.contains("traefik") || !services.contains_key(service_name) {
                    continue;
                }

                let service = services[service_name]
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

                let server_port = server.split(':').collect::<Vec<&str>>()[2];
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
