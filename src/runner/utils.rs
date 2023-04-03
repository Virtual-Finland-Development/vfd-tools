use anyhow::Result;
use std::{
    env,
    process::{Command, Stdio},
};

pub fn run_command(command: &str, quiet: bool) {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();

    let mut binding = Command::new(primary_command);
    let command = binding.args(command_parts);

    if quiet {
        command.stdout(Stdio::null()).stderr(Stdio::null());
    } else {
        command.stdout(Stdio::inherit()).stderr(Stdio::inherit());
    }

    let result = command.spawn().expect("Failed to spawn command").wait();
    if result.is_err() {
        print!("Command failed");
    }
}

pub fn format_runner_path(project_root_path: String) -> String {
    let mut runner_path = project_root_path;
    if env::var("HOME").is_ok() {
        let home_path = env::var("HOME").unwrap();
        if runner_path.starts_with(home_path.as_str()) {
            runner_path = runner_path.replace(home_path.as_str(), "~");
        }
    }
    if runner_path.contains("/../") {
        runner_path = runner_path.replace("/../", "/");
    }
    runner_path
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

pub fn ensure_docker_network() {
    run_command("docker network create vfd-network", true);
}
