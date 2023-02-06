# vfd-tools

Project development tools related to Virtual Finland Development (VFD) environment.

## Scripts

### **vfd** - a commander script (src/runner.sh)

A shell script for contolling docker-compose files located in separate project folders. The script will look for docker-compose files in the projects root directory and bring up/down the services defined in them.

#### **Usage:**

If need be, set the projects root directory with the `VFD_PROJECTS_ROOT` environment variable or with command-line arguments. By default it is set to `../`.

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

By default the `vfd`-script will use [traefik](https://github.com/traefik/traefik) as a reverse proxy for the services. For example, the `access-to-finland-demo-front` service will be available at `http://app-access-to-finland-demo-front.localhost` after bringing up the services.

The traefik dashboard should be available at `http://localhost:8081`. The generated hostnames of different services can be found from there with a syntax: `Host(<service-name>.localhost)`.

Disable the traefik setup by setting the `VFD_USE_TRAEFIK` environment variable to `false` or by using the `--no-traefik` command-line argument.
