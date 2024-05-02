.PHONY: vendor

COV:=$(shell cat .go.cov)

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

# Lint all the code.
lint:
	golangci-lint run --timeout 5m

# Fix the lint issues in the code (if possible).
fix-lint:
	golangci-lint run --timeout 5m --fix

# Format code.
format:
	go fmt ./...

# Run specs.
specs:
	gotestsum --rerun-fails --packages="./..." --junitfile test/reports/specs.xml -- -vet=off -race -mod vendor -covermode=atomic -coverpkg=./... -coverprofile=test/reports/profile.cov ./...

remove-generated-coverage:
	cat test/reports/profile.cov | grep -Ev "${COV}" > test/reports/final.cov

# Get the HTML coverage the code.
html-coverage: remove-generated-coverage
	go tool cover -html test/reports/final.cov -o test/reports/coverage.html

# Get the func coverage the code.
func-coverage: remove-generated-coverage
	go tool cover -func test/reports/final.cov

# Generate all coverage for the code.
coverage: html-coverage func-coverage

# Clean the reports.
clean-reports:
	rm -rf test/reports/*.*

# Run security checks.
sec:
	bin/build/sec/go

# Update go dep.
update-dep: get tidy vendor

# Update all go dep.
update-all-dep: get-all tidy vendor

# List outdated deps.
outdated-dep:
	go list -mod=mod -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}} {{.Update.Version}}{{end}}' -m all

# Encode a config.
encode-config:
	cat test/$(kind).yml | base64

# Create certificates.
create-certs:
	mkcert -key-file test/certs/key.pem -cert-file test/certs/cert.pem localhost
	mkcert -client -key-file test/certs/client-key.pem -cert-file test/certs/client-cert.pem localhost

# Encode the certificate.
encode-cert:
	cat test/certs/$(kind).pem | base64

# Start the environment.
start:
	bin/build/docker/env start

# Stop the environment.
stop:
	bin/build/docker/env stop
