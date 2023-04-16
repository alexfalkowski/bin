.PHONY: vendor

NAME=$(shell basename $(CURDIR))

# Setup ruby.
ruby-setup:
	make -C test setup

# Setup everything.
setup: go-dep ruby-setup ruby-dep

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

# Lint all the code.
lint: go-lint ruby-lint proto-lint

# Format proto.
proto-format:
	make -C api format

# Detect breaking changes in api.
proto-breaking:
	make -C api breaking

# Generate proto.
proto-generate:
	make -C api generate

# Fix the lint issues in the code (if possible).
fix-lint: go-fix-lint ruby-fix-lint proto-format

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
	go test -race -mod vendor -failfast -covermode=atomic -coverpkg=./... -coverprofile=test/reports/profile.cov ./...

# Get go dep.
go-get:
	go get $(module)

# Update go dep
go-update-dep: go-get tidy vendor

# Update all go deps.
go-dep-update-all:
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
ruby-dep-update-all:
	make -C test update-all

# Update proto deps.
proto-update-all:
	make -C api update-all

# Setup all deps.
dep: go-dep ruby-dep

# Update all deps.
dep-update-all: go-dep-update-all go-dep ruby-dep-update-all ruby-dep proto-update-all

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
	go test -race -ldflags="-X 'github.com/alexfalkowski/$(NAME)/cmd.Version=latest'" -mod vendor -c -tags features -covermode=atomic -o $(NAME) -coverpkg=./... github.com/alexfalkowski/$(NAME)

# Release to docker hub.
docker:
	bin/build/docker/push $(NAME)

# Start the environment.
start:
	bin/build/docker/env start

# Stop the environment.
stop:
	bin/build/docker/env stop
