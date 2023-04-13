BUILDER_IMAGE=vfd-tools-builder:1.68.2

prepare-build:
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

prepare-exec:
	@# Build the binary if it doesn't exist
	@if [ ! -f ./bin/vfd ]; then \
		echo "> Building the vfd binary..."; \
		make build; \
	fi

build: prepare-build build-vfd-tools create-build-link create-auto-completes

build-vfd-tools-builder:
	docker build -t $(BUILDER_IMAGE) -f ./builder.dockerfile .

build-vfd-tools: build-vfd-tools-builder
	@echo "> Building vfd-tools..."
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		$(BUILDER_IMAGE) \
		cargo build --release --target=$(TARGET)

create-build-link:
	@echo "> Creating build link..."
	@rm ./bin/vfd || true
	@ln -sf $(shell pwd)/target/$(TARGET)/release/vfd ./bin/vfd


create-auto-completes:
	@echo "> Generating auto-completes..."
	@./bin/vfd --generate-autocomplete zsh > ./scripts/generated/autocomplete.zsh
	@./bin/vfd --generate-autocomplete bash > ./scripts/generated/autocomplete.bash
	@./bin/vfd --generate-autocomplete fish > ./scripts/generated/autocomplete.fish

clean: clean-bin clean-build

clean-build:
	rm -rf ./target
	docker rmi $(BUILDER_IMAGE)

clean-bin:
	rm ./bin/vfd
	rm ./scripts/generated/autocomplete.*

