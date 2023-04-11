RUST_IMAGE = rust:1.68.1
TARGET:=$(shell ./scripts/resolve-build-target.sh)

build: build-vfd-tools create-auto-completes

build-vfd-tools:
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		$(RUST_IMAGE) \
		cargo build --release --target=$(TARGET) && \
		cp ./target/$(TARGET)/release/vfd ./target/release/vfd
create-auto-completes:
	./target/release/vfd --generate-autocomplete zsh > ./scripts/autocompletes/vfd.zsh
	./target/release/vfd --generate-autocomplete bash > ./scripts/autocompletes/vfd.bash
	./target/release/vfd --generate-autocomplete fish > ./scripts/autocompletes/vfd.fish
	./target/release/vfd --generate-autocomplete powershell > ./scripts/autocompletes/vfd.powershell
	./target/release/vfd --generate-autocomplete elvish > ./scripts/autocompletes/vfd.elvish
clean:
	rm -rf ./target
	docker rmi $(RUST_IMAGE)
