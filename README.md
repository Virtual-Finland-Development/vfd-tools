# vfd-tools

Project development tools

## Scripts

### `./bin/vfd`

Controller for different docker-compose files located in the project folders

#### Usage

If need be, set the projects root directory with the `VFD_PROJECTS_ROOT` environment variable or with cli arguments. By default it is set to `../`.

Examples:

- Print usage:

```bash
./bin/vfd --help
```

- Bring all services up:

```bash
./bin/vfd up
```

- Bring all services down:

```bash
./bin/vfd down
```

- Bring specific services up:

```bash
./bin/vfd up --services users-api,authentication-gw
```

### Shell shortuct setup

Add the following to your shell profile file eg. `.bashrc` or `.zshrc`:

```bash
export PATH=$PATH:/path/to/vfd-tools/bin
```

Replace `/path/to` with the path to the `vfd-tools` directory.

Restart your shell or source the profile file, then you can use the `vfd` command.
