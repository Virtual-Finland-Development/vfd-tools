
build:
	cargo build --release
install: build
	cp target/release/vfd ./bin/vfd