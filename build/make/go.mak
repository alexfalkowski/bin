.PHONY: vendor sync

NAME:=$(shell basename $(CURDIR))
MODULE:=$(shell head -n 1 go.mod | sed 's/module //')
SOURCE:=$(shell find . -name '*.go' -not -path './bin*/*' -not -path './test*/*' -not -path './vendor/*' -type f | sort)
PACKAGES:=$(shell go list $(sort $(dir $(SOURCE))))

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

# Setup deps.
dep: download tidy vendor

# Clean go caches.
clean-dep:
	@go clean -cache -testcache -fuzzcache -modcache

# Clean lint cache.
clean-lint:
	@$(PWD)/bin/build/go/lint cache clean

# Clean downloaded deps.
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

# Lint all the code.
lint: field-alignment golangci-lint

# Fix the lint issues in the code (if possible).
fix-lint: fix-field-alignment fix-golangci-lint

# Format code.
format:
	@go fmt ./...

# Run specs.
specs:
	@gotestsum --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=$(PACKAGES) -coverprofile=test/reports/profile.cov ./...

# Run package benchmark.
benchmark:
	@go test -vet=off -mod vendor -bench=. -run=Benchmark -benchmem -memprofile test/reports/mem.prof ./$(package)

# Run pprof for memprofile.
benchmark-pprof:
	@go tool pprof test/reports/mem.prof

remove-generated-coverage:
	@$(PWD)/bin/quality/go/covfilter

# Get the HTML coverage the code.
html-coverage: remove-generated-coverage
	@go tool cover -html test/reports/final.cov -o test/reports/coverage.html

# Get the func coverage the code.
func-coverage: remove-generated-coverage
	@go tool cover -func test/reports/final.cov

# Generate all coverage for the code.
coverage: html-coverage func-coverage

# Upload codecov information.
codecov-upload:
	@codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/final.cov

# Clean the reports.
clean-reports:
	@rm -rf test/reports/*.*

# Run security checks.
sec:
	@govulncheck -show verbose -test ./...

# Update go dep.
update-dep: get tidy vendor

# Update all go dep.
update-all-dep: get-all tidy vendor

# List outdated deps.
outdated-dep:
	@go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# Encode a config.
encode-config:
	@cat test/$(kind).yml | base64 -w 0

# Create certificates.
create-certs:
	@mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	@mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Create a diagram.
create-diagram:
	@goda graph $(MODULE)/$(package)/... | dot -Tpng -o assets/$(package).png

# Analyse binary size.
analyse:
	@gsa $(NAME)

# Calculate how much this project is worth.
money:
	@scc --no-duplicates --no-min-gen

# Start the environment.
start:
	@$(PWD)/bin/build/docker/env start

# Stop the environment.
stop:
	@$(PWD)/bin/build/docker/env stop
