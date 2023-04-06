use super::utils::run_command;
use anyhow::Result;

pub fn start_traefik() {
    run_command("docker compose -f docker-compose.traefik.yml up -d", false);
}

pub fn stop_traefik() {
    run_command("docker compose -f docker-compose.traefik.yml down", false);
}

pub async fn print_traefik_hosts_info() {
    async fn fetch_info() -> Result<Vec<String>> {
        let response = reqwest::get("http://localhost:8081/api/rawdata").await?;
        let response_body = response.text().await?;
        let hosts_info = serde_json::from_str::<serde_json::Value>(&response_body)?;
        let routers = &hosts_info["routers"];
        let mut hosts = Vec::new();

        for (_router_name, router) in routers.as_object().unwrap() {
            let rule = router["rule"].as_str().unwrap();
            if rule.contains("Host(") {
                let host = rule.replace("Host(`", "").replace("`)", "");
                if !hosts.contains(&host) && !host.contains("traefik") {
                    hosts.push(host);
                }
            }
        }

        Ok(hosts)
    }

    let hosts = fetch_info().await.unwrap_or_else(|_| Vec::new());
    if !hosts.is_empty() {
        println!("Hosts:");
        for host in hosts {
            println!("> http://{}", host);
        }
    } else {
        println!("No traefik hosts found");
    }
}
