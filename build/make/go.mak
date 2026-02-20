.PHONY: vendor sync

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

get:
	@go get $(module)

get-all:
	@go get -u all

# Download, tidy, and vendor Go module dependencies.
dep: download tidy vendor

# Clear Go build/test/fuzz/module caches.
clean-dep:
	@go clean -cache -testcache -fuzzcache -modcache

# Clear golangci-lint cache (no-op if golangci-lint is not installed).
clean-lint:
	@$(PWD)/bin/build/go/lint cache clean

# Refresh deps and caches when go.sum differs from master.
clean:
	@$(PWD)/bin/build/go/clean

field-alignment:
	@$(PWD)/bin/build/go/fa

fix-field-alignment:
	@$(PWD)/bin/build/go/fa -fix

golangci-lint:
	@$(PWD)/bin/build/go/lint run --timeout 5m

fix-golangci-lint:
	@$(PWD)/bin/build/go/lint run --timeout 5m --fix

# Run fieldalignment and golangci-lint.
lint: field-alignment golangci-lint

# Auto-fix fieldalignment and golangci-lint issues (best effort).
fix-lint: fix-field-alignment fix-golangci-lint

# Format Go packages (go fmt ./...).
format:
	@go fmt ./...

# Run tests with gotestsum (race + coverage) and write reports under test/reports/.
specs:
	@gotestsum --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=$(COVER_PACKAGES) -coverprofile=test/reports/profile.cov $(PACKAGES)

# Run benchmarks for package=$(package) and write test/reports/mem.prof.
benchmark:
	@go test -vet=off -mod vendor -bench=. -run=Benchmark -benchmem -memprofile test/reports/mem.prof ./$(package)

# Inspect benchmark memprofile via pprof (test/reports/mem.prof).
benchmark-pprof:
	@go tool pprof test/reports/mem.prof

remove-generated-coverage:
	@$(PWD)/bin/quality/go/covfilter

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
	@codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/final.cov

# Remove generated report artifacts under test/reports/.
clean-reports:
	@rm -rf test/reports/*.*

# Run govulncheck on the module (including tests).
sec:
	@govulncheck -show verbose -test ./...

# Update one module (set module=<path>) and re-vendor.
update-dep: get tidy vendor

# Update all modules (go get -u all) and re-vendor.
update-all-dep: get-all tidy vendor

# List available updates for direct (non-indirect) modules.
outdated-dep:
	@go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# Base64-encode test/$(kind).yml as a single line.
encode-config:
	@cat test/$(kind).yml | base64 -w 0

# Create server and client TLS certs under test/certs/ using mkcert.
create-certs:
	@mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	@mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Generate a dependency graph PNG for package=$(package) into assets/.
create-diagram:
	@goda graph $(MODULE)/$(package)/... | dot -Tpng -o assets/$(package).png

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
