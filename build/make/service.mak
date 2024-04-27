.PHONY: vendor

NAME:=$(shell basename $(CURDIR))

download:
	go mod download

tidy:
	go mod tidy

vendor:
	go mod vendor

# Lint all the go code.
go-lint:
	golangci-lint run --build-tags features --timeout 5m

# Fix the lint issues in the go code (if possible).
go-fix-lint:
	golangci-lint run --build-tags features --timeout 5m --fix

# Lint all the ruby code.
ruby-lint:
	make -C test lint

# Fix the lint issues in the ruby code (if possible).
ruby-fix-lint:
	make -C test fix-lint

# Lint Dockerfile.
docker-lint:
	hadolint Dockerfile

# Lint proto
proto-lint:
	make -C api lint

# Fix the lint issues in the proto code (if possible).
proto-fix-lint:
	make -C api fix-lint

# Lint all the code.
lint: go-lint ruby-lint proto-lint

# Fix the lint issues in the code (if possible).
fix-lint: go-fix-lint ruby-fix-lint proto-fix-lint

# Format go code.
go-format:
	go fmt ./...

# Format ruby code.
ruby-format:
	make -C test format

# Format proto.
proto-format:
	make -C api format

# Format all code.
format: go-format ruby-format proto-format

# List outdated go deps.
go-outdated-dep:
	go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# List outdated ruby deps.
ruby-outdated-dep:
	make -C test outdated-dep

# List outdated deps.
outdated-dep: go-outdated-dep ruby-outdated-dep

# Detect breaking changes in API.
proto-breaking:
	make -C api breaking

# Generate proto.
proto-generate:
	make -C api generate

# Push proto.
proto-push:
	make -C api push

sanitize-coverage:
	bin/quality/go/cov

# Get the HTML coverage for go.
html-coverage: sanitize-coverage
	go tool cover -html test/reports/final.cov

# Get the func coverage for go.
func-coverage: sanitize-coverage
	go tool cover -func test/reports/final.cov

# Send coveralls data.
goveralls: sanitize-coverage
	goveralls -coverprofile=test/reports/final.cov -service=circle-ci -repotoken=${COVERALLS_REPO_TOKEN}

# Run all the features.
features: build-test
	make -C test features

# Run all the specs.
specs:
	gotestsum --rerun-fails --packages="./..." --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=./... -coverprofile=test/reports/profile.cov ./...

# Get go dep.
go-get:
	go get $(module)

# Update go dep
go-update-dep: go-get tidy vendor

# Update all go deps.
go-update-all-dep:
	go get -u all

# Setup go deps.
go-dep: download tidy vendor

# Update ruby dep.
ruby-update-dep:
	make -C test gem=$(gem) update-dep

# Setup ruby deps.
ruby-dep:
	make -C test dep

# Update all ruby deps.
ruby-update-all-dep:
	make -C test update-all-dep

# Update proto deps.
proto-update-all-dep:
	make -C api update-all-dep

# Setup all deps.
dep: go-dep ruby-dep

# Update all deps.
update-all-dep: go-update-all-dep go-dep ruby-update-all-dep ruby-dep proto-update-all-dep

# Run go security checks.
go-sec:
	bin/build/sec/go

# Run security checks.
sec: go-sec

# Build release binary.
build:
	go build -race -ldflags="-X 'github.com/alexfalkowski/$(NAME)/cmd.Version=latest'" -mod vendor -o $(NAME) main.go

# Build test binary.
build-test:
	go test -vet=off -race -ldflags="-X 'github.com/alexfalkowski/$(NAME)/cmd.Version=latest'" -mod vendor -c -tags features -covermode=atomic -o $(NAME) -coverpkg=./... github.com/alexfalkowski/$(NAME)

# Build docker image.
build-docker:
	bin/build/docker/build $(NAME)

# Push to docker hub.
push-docker:
	bin/build/docker/push $(NAME)

# Verify using trivy.
trivy:
	bin/build/sec/trivy $(NAME)

# Encode a config.
encode-config:
	cat test/$(kind).yml | base64

# Create certificates.
create-certs:
	mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Start the environment.
start:
	bin/build/docker/env start

# Stop the environment.
stop:
	bin/build/docker/env stop
