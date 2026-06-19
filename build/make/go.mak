.PHONY: vendor sync

BIN_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../..)

NAME:=$(shell basename $(CURDIR))
MODULE:=$(shell head -n 1 go.mod | sed 's/module //')
SOURCE:=$(shell find . -name '*.go' -not -path './bin/*' -not -path './test/*' -not -path './vendor/*' -type f | sort)
PACKAGES=$(shell go list $(sort $(dir $(SOURCE))))
COVER_PACKAGES=$(shell echo $(PACKAGES) | tr ' ' ',')

export MODULE NAME
override export kind := $(value kind)
override export module := $(value module)
override export package := $(value package)
override export benchtime := $(value benchtime)

download:
	@go mod download

tidy:
	@go mod tidy

vendor:
	@go mod vendor

get:
	@go get "$$module"

get-all:
	@go get -u all

# Download, tidy, and vendor Go module dependencies.
dep: download tidy vendor

# Clear Go build/test/fuzz/module caches.
clean-dep:
	@go clean -cache -testcache -fuzzcache -modcache

# Update one module (set module=<path>) and re-vendor.
update-dep: get tidy vendor

# Update all modules (go get -u all) and re-vendor.
update-all-dep: get-all tidy vendor

# List available updates for direct (non-indirect) modules.
outdated-dep:
	@go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# Clear golangci-lint cache (no-op if golangci-lint is not installed).
clean-lint:
	@$(BIN_ROOT)/build/go/lint cache clean

# Refresh deps and caches when go.sum differs from master.
clean:
	@$(BIN_ROOT)/build/go/clean

# Run fieldalignment; .gofa may list comma-separated packages, default ./...
field-alignment:
	@$(BIN_ROOT)/build/go/fa

# Auto-fix fieldalignment; .gofa may list comma-separated packages, default ./...
fix-field-alignment:
	@$(BIN_ROOT)/build/go/fa -fix

# Run golangci-lint. Set package=internal/foo, not ./internal/foo, for one package.
golangci-lint:
	@$(BIN_ROOT)/build/go/lint run --timeout 5m

# Auto-fix golangci-lint. Set package=internal/foo, not ./internal/foo.
fix-golangci-lint:
	@$(BIN_ROOT)/build/go/lint run --timeout 5m --fix

# Run fieldalignment and golangci-lint.
lint: field-alignment golangci-lint

# Auto-fix fieldalignment and golangci-lint issues (best effort).
fix-lint: fix-field-alignment fix-golangci-lint

# Format Go packages (go fmt ./...).
format:
	@go fmt ./...

# Run tests with gotestsum (race + coverage) and write reports under test/reports/.
# Set package=internal/foo, not ./internal/foo, to test one package.
specs:
	@$(BIN_ROOT)/build/go/test "$(if $(package),,$(COVER_PACKAGES))" $(if $(package),,$(PACKAGES))

# Run benchmarks for package=internal/foo, or the module root when unset.
# Set benchtime=<duration-or-count> to pass -benchtime to go test.
benchmark:
	@$(BIN_ROOT)/quality/go/benchmark

# Inspect benchmark memprofile via pprof for package=$(package), or the module root when unset.
benchmark-pprof:
	@$(BIN_ROOT)/quality/go/benchmark-pprof

# Filter test/reports/profile.cov into final.cov using .gocov regex, default test.
remove-generated-coverage:
	@$(BIN_ROOT)/quality/go/covfilter

# Generate HTML coverage report from test/reports/final.cov.
html-coverage: remove-generated-coverage
	@go tool cover -html test/reports/final.cov -o test/reports/coverage.html

# Print function coverage summary from test/reports/final.cov.
func-coverage: remove-generated-coverage
	@go tool cover -func test/reports/final.cov

# Generate both HTML and function coverage reports.
coverage: html-coverage func-coverage

# Upload test/reports/final.cov to Codecov (codecovcli upload-process).
codecov-upload:
	@codecovcli --verbose upload-process -F service -f test/reports/final.cov

# Remove generated report artifacts while preserving report placeholders.
clean-reports:
	@$(BIN_ROOT)/build/shell/clean-reports test/reports

# Run govulncheck on the module (including tests).
govulncheck:
	@govulncheck -show verbose -test ./...

# Scan the repository with Trivy, excluding .ruby-lsp, bin, vendor, and test/vendor.
trivy-repo:
	@$(BIN_ROOT)/build/sec/trivy-repo

# Run security checks.
sec: govulncheck trivy-repo

# Base64-encode test/$(kind).yml as a single line.
encode-config:
	@$(BIN_ROOT)/build/test/encode-config

# Create server and client TLS certs under test/certs/ using mkcert.
create-certs:
	@mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	@mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost
	@cp "$$(mkcert -CAROOT)/rootCA.pem" test/certs/rootCA.pem

# Generate assets/<package>.png with goda+dot; package=internal/foo, default assets/diagram.png.
create-diagram:
	@$(BIN_ROOT)/quality/go/create-diagram

# Analyse binary size with gsa (non-fatal if gsa is missing/fails).
analyse:
	@gsa "$${NAME}" || true

# Report cost statistics with scc.
cost:
	@scc --no-duplicates --no-min-gen

# Start shared docker env, cloning/updating sibling ../docker over SSH as needed.
start:
	@$(BIN_ROOT)/build/docker/env start

# Stop shared docker env, cloning/updating sibling ../docker over SSH as needed.
stop:
	@$(BIN_ROOT)/build/docker/env stop
