rust_image = rust:1.68.1

prepare-exec:
	@# Build the binary if it doesn't exist
	@if [ ! -f ./target/release/vfd ]; then \
		echo "> Building the vfd binary..."; \
		make build; \
	fi

build: build-vfd-tools create-auto-completes

build-vfd-tools:
	@echo "> Building vfd-tools..."
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		$(rust_image) \
		cargo build --release
create-auto-completes:
	@echo "> Generating auto-completes..."
	@./bin/vfd --generate-autocomplete zsh > ./scripts/generated/autocomplete.zsh
	@./bin/vfd --generate-autocomplete bash > ./scripts/generated/autocomplete.bash
	@./bin/vfd --generate-autocomplete fish > ./scripts/generated/autocomplete.fish
	@./bin/vfd --generate-autocomplete powershell > ./scripts/generated/autocomplete.powershell
	@./bin/vfd --generate-autocomplete elvish > ./scripts/generated/autocomplete.elvish

clean:
	rm -rf ./target
	rm ./scripts/generated/autocomplete.*
	docker rmi $(rust_image)