.PHONY: vendor

NAME:=$(shell basename $(CURDIR))

download:
	@go mod download

tidy:
	@go mod tidy

vendor:
	@go mod vendor

field-alignment:
	@fieldalignment ./...

fix-field-alignment:
	@fieldalignment -fix ./...

golangci-lint:
	@golangci-lint run --build-tags features  --timeout 5m

fix-golangci-lint:
	@golangci-lint run --build-tags features --timeout 5m --fix

# Lint all the go code.
go-lint: field-alignment golangci-lint

# Fix the lint issues in the go code (if possible).
go-fix-lint: fix-field-alignment fix-golangci-lint

# Lint all the ruby code.
ruby-lint:
	@make -C test lint

# Fix the lint issues in the ruby code (if possible).
ruby-fix-lint:
	@make -C test fix-lint

# Lint Dockerfile.
docker-lint:
	@hadolint Dockerfile

# Lint all the code.
lint: go-lint ruby-lint

# Fix the lint issues in the code (if possible).
fix-lint: go-fix-lint ruby-fix-lint

# Format go code.
go-format:
	@go fmt ./...

# Format ruby code.
ruby-format:
	@make -C test format

# Format all code.
format: go-format ruby-format

# List outdated go deps.
go-outdated-dep:
	@go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# List outdated ruby deps.
ruby-outdated-dep:
	@make -C test outdated-dep

# List outdated deps.
outdated-dep: go-outdated-dep ruby-outdated-dep

sanitize-coverage:
	@bin/quality/go/covmerge

# Get the HTML coverage for go.
html-coverage: sanitize-coverage
	@go tool cover -html test/reports/final.cov -o test/reports/coverage.html

# Get the func coverage for go.
func-coverage: sanitize-coverage
	@go tool cover -func test/reports/final.cov

# Generate all coverage for the code.
coverage: html-coverage func-coverage

# Leave only coverage files.
leave-coverage:
	@find test/reports ! -name '*.cov' -type f -exec rm -f {} +

# Upload codecov information.
codecov-upload:
	@codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/final.cov

# Clean the reports.
clean-reports:
	@rm -rf test/reports/*.*

# Run all the features.
features: build-test
	@make -C test features

# Run all the specs.
specs:
	@gotestsum --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=./... -coverprofile=test/reports/profile.cov ./...

# Run pprof tool.
pprof:
	@go tool pprof test/reports/$(NAME)-$(cmd)-$(id)-$(kind).prof

# Get go dep.
go-get:
	@go get $(module)

# Update go dep
go-update-dep: go-get tidy vendor

# Update all go deps.
go-update-all-dep:
	@go get -u all

# Setup go deps.
go-dep: download tidy vendor

# Update ruby dep.
ruby-update-dep:
	@make -C test gem=$(gem) update-dep

# Setup ruby deps.
ruby-dep:
	@make -C test dep

# Update all ruby deps.
ruby-update-all-dep:
	@make -C test update-all-dep

# Update ruby bundler.
ruby-update-bundler:
	@make -C test update-bundler

# Setup all deps.
dep: go-dep ruby-dep

# Update all deps.
update-all-dep: go-update-all-dep go-dep ruby-update-all-dep ruby-dep

# Clean all ruby deps.
ruby-clean-dep:
	@make -C test clean-dep

# Clean all go deps.
go-clean-dep:
	@go clean -cache -testcache -fuzzcache -modcache

# CLean all deps.
clean-dep: ruby-clean-dep go-clean-dep

# Clean downloaded deps.
clean:
	@bin/build/go/clean

# Run go security checks.
go-sec:
	@govulncheck -show verbose -test ./...

# Run security checks.
sec: go-sec

# Build release binary.
build:
	@go build -race -mod vendor -o $(NAME) main.go

# Build test binary.
build-test:
	@go test -vet=off -race -mod vendor -c -tags features -covermode=atomic -o $(NAME) -coverpkg=./... github.com/alexfalkowski/$(NAME)

# Build docker image.
build-docker:
	@bin/build/docker/build $(NAME)

# Push to docker hub.
push-docker:
	@bin/build/docker/push $(NAME)

# Verify using trivy.
trivy:
	@bin/build/sec/trivy $(NAME)

# Encode a config.
encode-config:
	@cat test/$(kind).yml | base64 -w 0

# Create certificates.
create-certs:
	@mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	@mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Create a diagram.
create-diagram:
	@goda graph github.com/alexfalkowski/$(NAME)/$(package)/... | dot -Tpng -o assets/$(package).png

# Analyse binary size.
analyse:
	@gsa $(NAME)

# Start the environment.
start:
	@bin/build/docker/env start

# Stop the environment.
stop:
	@bin/build/docker/env stop
