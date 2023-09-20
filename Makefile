FUNCTION_NAME := function-add-k8s-labels-annotations

DOCKER_REGISTRY := steve
DOCKER_TAG := v0.0.1

# Local Build 
build-local:
	go build main.go -o function-add-labels-annotations

build: docker-build

# Run code generation - see input/generate.go
generate:
	go generate ./...

test:
	go test -cover ./...

lint:
	docker run --rm -v $(pwd):/app -v ~/.cache/golangci-lint/v1.54.2:/root/.cache -w /app golangci/golangci-lint:v1.54.2 golangci-lint run

push: docker-push

docker-build:
	docker build . -t $(DOCKER_REGISTRY)/$(FUNCTION_NAME):$(DOCKER_TAG)

docker-push:
	docker push $(DOCKER_REGISTRY)/$(FUNCTION_NAME):$(DOCKER_TAG)