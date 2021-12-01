.PHONY: build push

all: build 

publish: build push

build:
	docker build . --platform linux/amd64 -t starkandwayne/c3tk:latest

push:
	docker push starkandwayne/c3tk:latest

shell:
	docker run -it --rm --platform linux/amd64 -t starkandwayne/c3tk:latest

