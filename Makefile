RUST_IMAGE = rust:1.68.1

# Retrieve the machine's operating system information
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

# Define the target string based on the operating system and architecture
ifeq ($(OS),darwin)
    ifeq ($(ARCH),x86_64)
		TARGET := x86_64-apple-darwin
	else ifeq ($(ARCH),aarch64)
		TARGET := aarch64-apple-darwin
	else
		$(error Unsupported architecture: $(ARCH))
	endif
else ifeq ($(OS),linux)
    ifeq ($(ARCH),x86_64)
        TARGET := x86_64-unknown-linux-gnu
    else ifeq ($(ARCH),armv7l)
        TARGET := armv7-unknown-linux-gnueabihf
    else ifeq ($(ARCH),aarch64)
        TARGET := aarch64-unknown-linux-gnu
    else
        $(error Unsupported architecture: $(ARCH))
    endif
else
    $(error Unsupported operating system: $(OS))
endif

build: build-vfd-tools create-auto-completes

build-vfd-tools:
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		$(RUST_IMAGE) \
		cargo build --release --target=$(TARGET)
create-auto-completes:
	./target/release/vfd --generate-autocomplete zsh > ./scripts/autocompletes/vfd.zsh
	./target/release/vfd --generate-autocomplete bash > ./scripts/autocompletes/vfd.bash
	./target/release/vfd --generate-autocomplete fish > ./scripts/autocompletes/vfd.fish
	./target/release/vfd --generate-autocomplete powershell > ./scripts/autocompletes/vfd.powershell
	./target/release/vfd --generate-autocomplete elvish > ./scripts/autocompletes/vfd.elvish
clean:
	rm -rf ./target
	docker rmi $(RUST_IMAGE)
