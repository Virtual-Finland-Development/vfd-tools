VFD_TOOLS_IMAGE=vfd-tools:v1

install: build

build: build-vfd-tools generate-auto-completes

build-vfd-tools:
	@echo "> Building vfd tools..."
	docker build -t ${VFD_TOOLS_IMAGE} .

generate-auto-completes:
	@echo "> Generating auto-completes..."
	@docker run --rm -v $(shell pwd)/settings.json:/vfd-tools/settings.json ${VFD_TOOLS_IMAGE} --generate-autocomplete zsh > ./scripts/generated/autocomplete.zsh
	@docker run --rm -v $(shell pwd)/settings.json:/vfd-tools/settings.json ${VFD_TOOLS_IMAGE} --generate-autocomplete bash > ./scripts/generated/autocomplete.bash
	@docker run --rm -v $(shell pwd)/settings.json:/vfd-tools/settings.json ${VFD_TOOLS_IMAGE} --generate-autocomplete fish > ./scripts/generated/autocomplete.fish
	@chmod +x ./scripts/generated/autocomplete.*

clean:
	@echo "> Cleaning..."
	@docker rmi ${VFD_TOOLS_IMAGE} || true
