# vfd-tools

Project development tools related to Virtual Finland Development (VFD) environment.

### **vfd** - a commander script (src/main.rs)

A script for contolling docker-compose files located in separate vfd-project folders.

#### **Build requirements**

The script is written in Rust but and needs to be compiled with the Rust toolchain, but for convenience a makefile with a dockerized build environment is provided and as such the only requirement is to have `docker` and `make` installed:

- docker - https://docs.docker.com/get-docker/
- make - https://www.gnu.org/software/make/
- git (optional) - https://git-scm.com/downloads

#### Install

Add the following to your shell profile file eg. `.bashrc` or `.zshrc`:

```shell
source /path/to/vfd-tools/scripts/shell-setup.sh
```

For fish shell add the following to your `config.fish` file:

```shell
source /path/to/vfd-tools/scripts/shell-setup.fish
```

Replace `/path/to/vfd-tools` with the actual path to the `vfd-tools` directory.

Restart your shell or source the profile file, then you can use the `vfd` as a global shell command:

```shell
vfd --help
```

#### Use without shell setup

If you don't want to add the `vfd` command to your shell profile, you can use the `vfd` script directly:

Install:

```shell
make -C /path/to/vfd-tools build
```

Exec:

```shell
/path/to/vfd-tools/bin/vfd --help
```

#### **Usage:**

The script will look for docker-compose files in the vfd-projects root directory and bring up/down the services defined in them.

If need be, set the vfd-projects root directory with the `VFD_PROJECTS_ROOT` environment variable or with command-line option: `--workdir path/to/services`. By default the services root is set to the parent folder (`../`) of the `vfd-tools` project.

##### **Examples:**

Print usage:

```shell
vfd --help
```

Bring all services up:

```shell
vfd up
```

Bring all services down:

```shell
vfd down
```

List traefik domains of all services:

```shell
vfd list
```

Bring specific service profiles up:

```shell
vfd up --profiles virtual-finland
```

Bring specific services up:

```shell
vfd up --services users-api,authentication-gw
```

Tail the logs of a specific docker compose service in a project:

```shell
vfd logs --services=authentication-gw authgw -f
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

# Resources

- https://docs.rs/clap/latest/clap/_derive/_tutorial/index.html
