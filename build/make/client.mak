.PHONY: vendor

NAME:=$(shell basename $(CURDIR))
MODULE:=$(shell head -n 1 go.mod | sed 's/module //')
SOURCE:=$(shell find . -name '*.go' -not -path './bin*/*' -not -path './test*/*' -not -path './vendor/*' -type f | sort)
PACKAGES=$(shell go list $(sort $(dir $(SOURCE))))
COVER_PACKAGES=$(shell echo $(PACKAGES) | tr ' ' ',')

download:
	@go mod download

tidy:
	@go mod tidy

vendor:
	@go mod vendor

field-alignment:
	@$(PWD)/bin/build/go/fa

fix-field-alignment:
	@$(PWD)/bin/build/go/fa -fix

golangci-lint:
	@$(PWD)/bin/build/go/lint run --build-tags features  --timeout 5m

fix-golangci-lint:
	@$(PWD)/bin/build/go/lint run --build-tags features --timeout 5m --fix

# Run fieldalignment and golangci-lint (build-tags=features).
go-lint: field-alignment golangci-lint

# Auto-fix fieldalignment and golangci-lint issues (best effort).
go-fix-lint: fix-field-alignment fix-golangci-lint

# Lint Ruby code in test/ with RuboCop.
ruby-lint:
	@make -C test lint

# Auto-correct RuboCop offenses in test/ (best effort).
ruby-fix-lint:
	@make -C test fix-lint

# Lint Dockerfile with hadolint.
docker-lint:
	@hadolint Dockerfile

# Lint Go and Ruby test harness.
lint: go-lint ruby-lint

# Auto-fix lint issues in Go and Ruby test harness (best effort).
fix-lint: go-fix-lint ruby-fix-lint

# Format Go packages (go fmt ./...).
go-format:
	@go fmt ./...

# Format Ruby in test/ (delegates to test/ Makefile).
ruby-format:
	@make -C test format

# Format Go and Ruby.
format: go-format ruby-format

# List available updates for direct (non-indirect) Go modules.
go-outdated-dep:
	@go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# List outdated explicit gems in test/.
ruby-outdated-dep:
	@make -C test outdated-dep

# List outdated Go modules and Ruby gems.
outdated-dep: go-outdated-dep ruby-outdated-dep

sanitize-coverage:
	@$(PWD)/bin/quality/go/covmerge

# Generate HTML coverage report from test/reports/final.cov.
html-coverage: sanitize-coverage
	@go tool cover -html test/reports/final.cov -o test/reports/coverage.html

# Print function coverage summary from test/reports/final.cov.
func-coverage: sanitize-coverage
	@go tool cover -func test/reports/final.cov

# Generate both HTML and function coverage reports.
coverage: html-coverage func-coverage

# Remove non-coverage artifacts under test/reports/.
leave-coverage:
	@find test/reports ! -name '*.cov' -type f -exec rm -f {} +

# Upload test/reports/final.cov to Codecov (codecovcli upload-process).
codecov-upload:
	@codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/final.cov

# Remove generated report artifacts under test/reports/.
clean-reports:
	@rm -rf test/reports/*.*

# Run cucumber features in test/ (builds the test binary first).
features: build-test
	@make -C test features

# Run cucumber benchmarks in test/ (builds the release binary first).
benchmarks: build
	@make -C test benchmarks

# Run Go tests with gotestsum (race + coverage) and write reports under test/reports/.
specs:
	@gotestsum --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=$(COVER_PACKAGES) -coverprofile=test/reports/profile.cov $(PACKAGES)

# Open pprof for a captured profile under test/reports/ (set cmd/id/kind).
pprof:
	@go tool pprof test/reports/$(NAME)-$(cmd)-$(id)-$(kind).prof

# Fetch a Go module (set module=<path>).
go-get:
	@go get $(module)

# Update one Go module (module=<path>) and re-vendor.
go-update-dep: go-get tidy vendor

# Update all Go modules (go get -u all).
go-update-all-dep:
	@go get -u all

# Download, tidy, and vendor Go module dependencies.
go-dep: download tidy vendor

# Update a single gem in test/ (set gem=<name>).
ruby-update-dep:
	@make -C test gem=$(gem) update-dep

# Install gem dependencies in test/.
ruby-dep:
	@make -C test dep

# Update all gems in test/.
ruby-update-all-dep:
	@make -C test update-all-dep

# Update bundler in test/.
ruby-update-bundler:
	@make -C test update-bundler

# Install Go deps and test/ Ruby deps.
dep: go-dep ruby-dep

# Update all Go modules and test/ gems.
update-all-dep: go-update-all-dep go-dep ruby-update-all-dep ruby-dep

# Remove unused gems from test/ (bundler clean).
ruby-clean-dep:
	@make -C test clean-dep

# Clear Go build/test/fuzz/module caches.
go-clean-dep:
	@go clean -cache -testcache -fuzzcache -modcache

# Clean Go caches and test/ Ruby deps.
clean-dep: ruby-clean-dep go-clean-dep

# Clear golangci-lint cache (no-op if golangci-lint is not installed).
clean-lint:
	@$(PWD)/bin/build/go/lint cache clean

# Refresh deps and caches when go.sum differs from master.
clean:
	@$(PWD)/bin/build/go/clean

# Run govulncheck on the module (including tests).
go-sec:
	@govulncheck -show verbose -test ./...

# Run security checks.
sec: go-sec

# Build a static-ish release binary named $(NAME).
build:
	@go build -ldflags="-s -w" -buildvcs=false -tags netgo -a -o $(NAME) .

# Build a test binary with -tags features and coverage instrumentation.
build-test:
	@go test -vet=off -race -mod vendor -c -tags features -covermode=atomic -coverpkg=$(COVER_PACKAGES) -o $(NAME) $(MODULE)

# Build a test docker image tagged alexfalkowski/$(NAME):test.$(platform).
build-docker:
	@$(PWD)/bin/build/docker/build $(NAME) $(platform)

# Push the image to docker hub (only if the last commit subject starts with chore).
push-docker:
	@$(PWD)/bin/build/docker/push $(NAME) $(platform)

# Create and push multi-arch manifests (only if the last commit subject starts with chore).
manifest-docker:
	@$(PWD)/bin/build/docker/manifest $(NAME)

# Scan the test image with Trivy (CRITICAL severity).
trivy-image:
	@$(PWD)/bin/build/sec/trivy-image $(NAME) $(platform)

# Scan the repository with Trivy (CRITICAL severity).
trivy-repo:
	@$(PWD)/bin/build/sec/trivy-repo

# Base64-encode test/$(kind).yml as a single line.
encode-config:
	@cat test/$(kind).yml | base64 -w 0

# Create server and client TLS certs under test/certs/ using mkcert.
create-certs:
	@mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	@mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Generate a dependency graph PNG for package=$(package) into assets/.
create-diagram:
	@goda graph github.com/alexfalkowski/$(NAME)/$(package)/... | dot -Tpng -o assets/$(package).png

# Analyse binary size with gsa (non-fatal if gsa is missing/fails).
analyse:
	@gsa $(NAME) || true

# Report code statistics with scc.
money:
	@scc --no-duplicates --no-min-gen

# Start shared docker environment via the sibling ../docker repo.
start:
	@$(PWD)/bin/build/docker/env start

# Stop shared docker environment via the sibling ../docker repo.
stop:
	@$(PWD)/bin/build/docker/env stop
