SHELL=bash
BUILDER_IMAGE=vfd-tools-builder:1.68.2
PRE_BUILD_TARGETS=aarch64-apple-darwin \
        x86_64-apple-darwin \
		x86_64-unknown-linux-gnu \
        x86_64-unknown-linux-musl

# Fails to compile openssl-sys
# aarch64-unknown-linux-gnu \
# aarch64-unknown-linux-musl \
# armv7-unknown-linux-musleabihf \

prepare-build-target:
OS:=$(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH:=$(shell uname -m)

ifeq ($(OS),linux)
  ifeq ($(ARCH),armv7l)
    TARGET:=armv7-unknown-linux-musleabihf
  else
    TARGET:=$(ARCH)-unknown-linux-gnu
  endif
else ifeq ($(OS),darwin)
  ifeq ($(ARCH),x86_64)
    TARGET:=x86_64-apple-darwin
  else
    TARGET:=aarch64-apple-darwin
  endif
endif
ifeq ($(TARGET),)
  $(error "Unsupported OS/ARCH combination: $(OS)/$(ARCH)")
endif

prepare-exec: prepare-build-target
	@# Build the binary if it doesn't exist
	@if [ ! -f ./bin/vfd ]; then \
		if [ -f ./builds/$(TARGET)/vfd ]; then \
			echo "> Linking the pre-built vfd-tools binary..."; \
			rm ./bin/vfd || true; \
			ln -s $(shell pwd)/builds/$(TARGET)/vfd ./bin/vfd; \
		else \
			echo "> Building the vfd binary..."; \
			make build; \
		fi \
	fi

build: prepare-build-target build-vfd-tools create-build-link create-auto-completes
	@echo "> Done!"

build-vfd-tools-builder:
	@echo "> Building vfd-tools builder..."
	docker build -t $(BUILDER_IMAGE) -f ./builder.dockerfile .

build-vfd-tools: build-vfd-tools-builder
	@echo "> Building vfd-tools for $(TARGET)..."
	if [[ $(TARGET) == *darwin ]]; then \
		docker run --rm --name=vfd-tools-builder \
			-v /var/run/docker.sock:/var/run/docker.sock \
			-w /vfd-tools-builder/cross \
			$(BUILDER_IMAGE) \
			cargo build-docker-image $(TARGET)-cross --tag local \
				--build-arg 'MACOS_SDK_URL=https://github.com/joseluisq/macosx-sdks/releases/download/12.3/MacOSX12.3.sdk.tar.xz'; \
	fi
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		-v /var/run/docker.sock:/var/run/docker.sock \
		$(BUILDER_IMAGE) \
		cross build --release --target=$(TARGET) && \
		mkdir -p ./builds/$(TARGET) && \
		cp ./target/$(TARGET)/release/vfd ./builds/$(TARGET)/vfd

create-build-link:
	@echo "> Creating build links..."
	@rm ./bin/vfd || true
	@ln -sf $(shell pwd)/builds/$(TARGET)/vfd ./bin/vfd

create-auto-completes:
	@echo "> Generating auto-completes..."
	@./bin/vfd --generate-autocomplete zsh > ./scripts/generated/autocomplete.zsh
	@./bin/vfd --generate-autocomplete bash > ./scripts/generated/autocomplete.bash
	@./bin/vfd --generate-autocomplete fish > ./scripts/generated/autocomplete.fish

build-prebuilt-binaries: build-vfd-tools-builder
	@echo "> Building the pre-built binaries..."
	@set -e
	@for BUILD_TARGET in $(PRE_BUILD_TARGETS); do \
        echo "Building vfd for $$BUILD_TARGET..."; \
        make build-vfd-tools TARGET=$$BUILD_TARGET; \
    done
	
clean: clean-build

clean-binaries:
	rm -rf ./builds/*
	
clean-build:
	rm -rf ./target
	docker rmi $(BUILDER_IMAGE)
