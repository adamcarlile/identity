DOCKER_IMAGE_NAME ?= identity_service
SHELL = /bin/bash

PATH:=$(PATH):$(GOPATH)/bin

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

build: docker/build
	@exit 0
