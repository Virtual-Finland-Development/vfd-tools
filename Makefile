BUILDER_IMAGE=vfd-tools-builder:1.68.2
TARGET:=$(shell ./scripts/resolve-build-target.sh)

prepare-exec:
	@# Build the binary if it doesn't exist
	@if [ ! -f ./bin/vfd ]; then \
		echo "> Building the vfd binary..."; \
		make build; \
	fi

build: build-vfd-tools create-auto-completes

build-vfd-tools-builder:
	docker build -t $(BUILDER_IMAGE) -f ./builder.dockerfile .

build-vfd-tools: build-vfd-tools-builder
	@echo "> Building vfd-tools..."
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		$(BUILDER_IMAGE) \
		cargo build --release --target=$(TARGET) && \
		cp ./target/$(TARGET)/release/vfd ./bin/vfd

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

