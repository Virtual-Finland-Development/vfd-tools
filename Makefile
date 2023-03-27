rust_image = rust:1.68.1

build: 
	docker run --rm --name=vfd-tools \
		-v $(shell realpath .):/vfd-tools -w /vfd-tools \
		$(rust_image) \
		cargo build --release
install: build 
	cp ./target/release/vfd ./bin/vfd
clean:
	rm -rf ./target
	docker rmi $(rust_image)
