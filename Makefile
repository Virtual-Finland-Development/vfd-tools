build: 
	docker run --rm --name=vfd-tools \
		-v $(shell realpath .):/vfd-tools -w /vfd-tools \
		rust:1.68.1 \
		cargo build --release
install: build 
	cp ./target/release/vfd ./bin/vfd
clean:
	rm -rf ./target
