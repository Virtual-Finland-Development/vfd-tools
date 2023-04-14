# syntax=docker/dockerfile:1
FROM docker as dockerx
COPY --from=docker/buildx-bin:latest /buildx /usr/libexec/docker/cli-plugins/docker-buildx

FROM rust:1

# Install docker
RUN curl -fsSL https://get.docker.com | sh
COPY --from=dockerx /usr/libexec/docker/cli-plugins/docker-buildx /usr/libexec/docker/cli-plugins/docker-buildx

# set CROSS_CONTAINER_IN_CONTAINER to inform `cross` that it is executed from within a container
ENV CROSS_CONTAINER_IN_CONTAINER=true

# install `cross` and dependencies
RUN cargo install cross --git https://github.com/cross-rs/cross
RUN cargo install cargo-xtask

WORKDIR /vfd-tools-builder

# Setup build environment for darwin targets
RUN git clone https://github.com/cross-rs/cross && \
    cd cross && \
    git submodule update --init --remote

# Configure
RUN cargo xtask configure-crosstool aarch64-apple-darwin && \
    cargo xtask configure-crosstool x86_64-apple-darwin

