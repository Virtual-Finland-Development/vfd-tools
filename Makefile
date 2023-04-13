BUILDER_IMAGE=vfd-tools-builder:1.68.2
TARGET:=$(shell ./scripts/resolve-build-target.sh)

build: build-vfd-tools create-auto-completes

build-vfd-tools-builder:
	docker build -t $(BUILDER_IMAGE) -f ./builder.dockerfile .

build-vfd-tools: build-vfd-tools-builder
	docker run --rm --name=vfd-tools-builder \
		-v $(shell pwd):/vfd-tools -w /vfd-tools \
		$(BUILDER_IMAGE) \
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
	docker rmi $(BUILDER_IMAGE)
