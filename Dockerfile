FROM rust:1

WORKDIR /vfd-tools

COPY Cargo.toml Cargo.lock ./ 
COPY src ./src

RUN cargo build --release

ENTRYPOINT ["./target/release/vfd"]