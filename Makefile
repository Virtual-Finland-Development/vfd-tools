SHELL=bash
BUILDER_IMAGE=vfd-tools-builder:1.68.2
DARWIN_BUILDER_IMAGE=joseluisq/rust-linux-darwin-builder:1.68.2
PRE_BUILD_TARGETS=aarch64-apple-darwin \
		x86_64-apple-darwin \
        aarch64-unknown-linux-gnu \
		aarch64-unknown-linux-musl \
		armv7-unknown-linux-musleabihf \
		x86_64-unknown-linux-gnu \
        x86_64-unknown-linux-musl

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

install: prepare-build-target ensure-builds-folder
	@# Download or build the binary if it doesn't exist
	@if [ ! -e ./bin/vfd ]; then \
		set -e; \
		if echo "$(PRE_BUILD_TARGETS)" | grep -qw "$(TARGET)" ; then \
			echo "> Downloading the pre-built vfd-tools binary..."; \
			docker run --rm \
				-v $(shell pwd):/vfd-tools -w /vfd-tools \
				alpine sh -c '\
				wget -q https://github.com/Virtual-Finland-Development/vfd-tools/releases/download/v1/$(TARGET).tar.gz -P ./.builds && \
				wget -q https://github.com/Virtual-Finland-Development/vfd-tools/releases/download/v1/$(TARGET).tar.gz.md5 -P ./.builds && \
				md5sum -c ./.builds/$(TARGET).tar.gz.md5 && \
				tar -xzf ./.builds/$(TARGET).tar.gz -C ./.builds && \
				rm ./.builds/$(TARGET).tar.gz'; \
		fi; \
		if [ ! -f ./.builds/$(TARGET)/vfd ]; then \
			echo "> Building the vfd binary..."; \
			make build; \
		fi; \
		echo "> Linking the pre-built vfd-tools binary..."; \
		ln -s $(shell pwd)/.builds/$(TARGET)/vfd ./bin/vfd; \
	fi

build: prepare-build-target build-vfd-tools create-build-link create-auto-completes
	@echo "> Done!"

build-vfd-tools-builder:
	@echo "> Building vfd-tools builder..."
	docker build -t $(BUILDER_IMAGE) -f ./builder.dockerfile .

build-vfd-tools: build-vfd-tools-builder
	@echo "> Building vfd-tools for $(TARGET)..."
	@if [[ $(TARGET) == *darwin ]]; then \
		docker run --rm \
			-v $(shell pwd):/vfd-tools -w /vfd-tools \
			-e CC=oa64-clang -e CXX=oa64-clang++ \
			$(DARWIN_BUILDER_IMAGE) \
			cargo build --release --target=$(TARGET) && \
			mkdir -p ./.builds/$(TARGET) && \
			cp ./target/$(TARGET)/release/vfd ./.builds/$(TARGET)/vfd;  \
	else \
		docker run --rm \
			-v $(shell pwd):/vfd-tools -w /vfd-tools \
			-v /var/run/docker.sock:/var/run/docker.sock \
			$(BUILDER_IMAGE) \
			cross build --release --target=$(TARGET) && \
			mkdir -p ./.builds/$(TARGET) && \
			cp ./target/$(TARGET)/release/vfd ./.builds/$(TARGET)/vfd; \
	fi

create-build-link: prepare-build-target
	@echo "> Creating build links..."
	@if [ -f ./bin/vfd ]; then \
		rm ./bin/vfd; \
	fi
	@ln -sf $(shell pwd)/.builds/$(TARGET)/vfd ./bin/vfd

create-auto-completes:
	@echo "> Generating auto-completes..."
	@./bin/vfd --generate-autocomplete zsh > ./scripts/generated/autocomplete.zsh
	@./bin/vfd --generate-autocomplete bash > ./scripts/generated/autocomplete.bash
	@./bin/vfd --generate-autocomplete fish > ./scripts/generated/autocomplete.fish
	@chmod +x ./scripts/generated/autocomplete.*

build-binaries: build-vfd-tools-builder
	@echo "> Building the pre-built binaries..."
	@set -e
	@for BUILD_TARGET in $(PRE_BUILD_TARGETS); do \
        echo "Building vfd for $$BUILD_TARGET..."; \
        make build-vfd-tools TARGET=$$BUILD_TARGET; \
    done

create-release-archive-files: store-build-hash build-binaries
	@echo "> Creating release archive files..."
	@set -e
	@for BUILD_TARGET in $(PRE_BUILD_TARGETS); do \
		tar -czf ./.builds/$$BUILD_TARGET.tar.gz -C ./.builds $$BUILD_TARGET; \
		md5sum ./.builds/$$BUILD_TARGET.tar.gz > ./.builds/$$BUILD_TARGET.tar.gz.md5; \
	done

ensure-builds-folder:
	@mkdir -p ./.builds

clean: clean-build

clean-binaries:
	rm -rf ./.builds/*
	
clean-build:
	rm -rf ./target || true
	docker rmi $(BUILDER_IMAGE) || true
	docker rmi $(DARWIN_BUILDER_IMAGE) || true

store-build-hash:
	@echo "> Storing the build hash..."
	@$(shell make -s generate-build-hash > ./.builds/version-hash.md5)
	@echo "> Stored: $(shell cat ./.builds/version-hash.md5)"
generate-build-hash: ensure-builds-folder
	@find ./src -type f -print0 | sort -z | xargs -0 cat | md5sum | cut -d ' ' -f 1
check-published-build-hash:
	@docker run --rm alpine sh -c 'wget -q -O - https://github.com/Virtual-Finland-Development/vfd-tools/releases/download/v1/version-hash.md5'

check-updates:
	@echo "> Checking for updates..."
	@if [ "$(shell make -s generate-build-hash)" != "$(shell make -s check-published-build-hash)" ]; then \
		echo "-> There is a new version available!"; \
		echo "-> Please run 'vfd self-update' to update to the latest version."; \
	else \
		echo "-> You are running the latest version!"; \
	fi \