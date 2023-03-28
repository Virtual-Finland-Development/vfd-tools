use anyhow::Result;
use std::{
    env,
    process::{Command, Stdio},
};

pub fn run_command(command: &str, quiet: bool) -> Result<()> {
    let mut command_parts = command.split(' ');
    let primary_command = command_parts.next().unwrap();

    let mut binding = Command::new(primary_command);
    let command = binding.args(command_parts);

    if quiet {
        command.stdout(Stdio::null()).stderr(Stdio::null());
    } else {
        command.stdout(Stdio::inherit()).stderr(Stdio::inherit());
    }

    command.spawn()?.wait()?;
    Ok(())
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
    let response = reqwest::get("http://localhost:8081/api/rawdata")
        .await
        .expect("Failed to get traefik hosts info");
    let response_body = response
        .text()
        .await
        .expect("Failed to retrieve traefik hosts info");
    let hosts_info = serde_json::from_str::<serde_json::Value>(&response_body)
        .expect("Failed to parse traefik hosts info");
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

    if !hosts.is_empty() {
        for host in hosts {
            println!("> Host: http://{}", host);
        }
    } else {
        println!("No traefik hosts found");
    }
}

pub fn ensure_docker_network() {
    run_command("docker network create vfd-network", true).unwrap_or_default();
}
