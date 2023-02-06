# vfd-tools

Project development tools related to Virtual Finland Development (VFD) environment.

## Scripts

### `vfd (src/runner.sh)`

Shell script for contolling docker-compose files located in separate project folders

#### Usage

If need be, set the projects root directory with the `VFD_PROJECTS_ROOT` environment variable or with command-line arguments. By default it is set to `../`.

##### Examples:

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

### Shell shortuct setup

Add the following to your shell profile file eg. `.bashrc` or `.zshrc`:

```bash
export PATH=$PATH:/path/to/vfd-tools/bin
```

Replace `/path/to` with the path to the `vfd-tools` directory.

Restart your shell or source the profile file, then you can use the `vfd` as a global shell command:

```bash
vfd --help
```
