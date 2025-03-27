.PHONY: vendor sync

NAME:=$(shell basename $(CURDIR))

download:
	go mod download

tidy:
	go mod tidy

vendor:
	go mod vendor

get:
	go get $(module)

get-all:
	go get -u all

# Setup deps.
dep: download tidy vendor

# Clean all deps.
clean-dep:
	go clean -cache -testcache -fuzzcache -modcache

# Reinitialize the deps.
re-dep:
	make dep
	make clean-dep
	make dep

field-alignment:
	fieldalignment ./...

fix-field-alignment:
	fieldalignment -fix ./...

golangci-lint:
	golangci-lint run --timeout 5m

fix-golangci-lint:
	golangci-lint run --timeout 5m --fix

# Lint all the code.
lint: field-alignment golangci-lint

# Fix the lint issues in the code (if possible).
fix-lint: fix-field-alignment fix-golangci-lint

# Format code.
format:
	go fmt ./...

# Run specs.
specs:
	gotestsum --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=./... -coverprofile=test/reports/profile.cov ./...

# Run package benchmark.
benchmark:
	go test -vet=off -race -mod vendor -bench=. -run=Benchmark -benchmem -memprofile test/reports/mem.prof ./$(package)

# Run pprof for memprofile.
benchmark-pprof:
	go tool pprof test/reports/mem.prof

remove-generated-coverage:
	bin/quality/go/covfilter

# Get the HTML coverage the code.
html-coverage: remove-generated-coverage
	go tool cover -html test/reports/final.cov -o test/reports/coverage.html

# Get the func coverage the code.
func-coverage: remove-generated-coverage
	go tool cover -func test/reports/final.cov

# Generate all coverage for the code.
coverage: html-coverage func-coverage

# Upload codecov information.
codecov-upload:
	codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/final.cov

# Clean the reports.
clean-reports:
	rm -rf test/reports/*.*

# Run security checks.
sec:
	govulncheck -show verbose -test ./...

# Update go dep.
update-dep: get tidy vendor

# Update all go dep.
update-all-dep: get-all tidy vendor

# List outdated deps.
outdated-dep:
	go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# Encode a config.
encode-config:
	cat test/$(kind).yml | base64 -w 0

# Create certificates.
create-certs:
	mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Create a diagram.
create-diagram:
	goda graph github.com/alexfalkowski/$(NAME)/$(package)/... | dot -Tpng -o assets/$(package).png

# Analyse binary size.
analyse:
	gsa $(NAME)

# Start the environment.
start:
	bin/build/docker/env start

# Stop the environment.
stop:
	bin/build/docker/env stop
