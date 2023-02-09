# vfd-tools

Project development tools related to Virtual Finland Development (VFD) environment.

## Scripts

### **vfd** - a commander script (src/runner.sh)

A shell script for contolling docker-compose files located in separate vfd-project folders.

### **Requirements**

For listing hostnames of the services, the script requires the `jq` and `curl` command-line tools to be installed.

#### **Usage:**

The script will look for docker-compose files in the vfd-projects root directory and bring up/down the services defined in them.

If need be, set the vfd-projects root directory with the `VFD_PROJECTS_ROOT` environment variable or with command-line option: `--workdir path/to/services`. By default the services root is set to the parent folder (`../`) of the `vfd-tools` project.

##### **Examples:**

Print usage:

```bash
./bin/vfd --help
```

Bring all services up:

```bash
./bin/vfd up
```

Bring all services down:

```bash
./bin/vfd down
```

Bring specific services up:

```bash
./bin/vfd up --services users-api,authentication-gw
```

Tail the logs of specific services of a project:

```bash
vfd logs --services=authentication-gw authgw -f
```

### Shell shortcut setup

Add the following to your shell profile file eg. `.bashrc` or `.zshrc`:

```bash
export PATH=$PATH:/path/to/vfd-tools/bin
```

Replace `/path/to` with the path to the `vfd-tools` directory.

Restart your shell or source the profile file, then you can use the `vfd` as a global shell command:

```bash
vfd --help
```

## Traefik setup

By default the `vfd` -script will use [traefik](https://github.com/traefik/traefik) as a reverse proxy for the services. For example, the `access-to-finland-demo-front` service will be available at `http://app-access-to-finland-demo-front.localhost` after bringing up the services.

The traefik dashboard should be available at `http://localhost:8081`. The generated hostnames of different services can be found from there with a default syntax: `Host(<service-name>-<project-name>.localhost)`.

The service host can be changed at project-level by adding a traefik label to the service in the `docker-compose.yml` file. For example:

```yaml
services:
    demoApp:
    ...
    labels:
        - traefik.http.routers.demoApp.rule=Host(`demoApp.localhost`)
```

In the above example the `demoApp` is a reference to the service name and `demoApp.localhost` is the hostname of the service.

### Disabling traefik

Disable the traefik setup by setting the `VFD_USE_TRAEFIK` environment variable to `false` or by using the `--no-traefik` command-line argument.

## Notes:

- the authentication-gw service will report an `authentication-gw-caddy` container error of ports being already in use on startup, this is expected and can be ignored
  - the caddy might be later departed from the authentication-gw service with traefik being used as a reverse proxy instead
- with Windows subsystem for linux (WSL 2), there seems to be some networking issues when restarting the traefik container often, this should be fixable by restarting the WSL 2 instance (eg. `wsl --shutdown`) or by restarting the computer
