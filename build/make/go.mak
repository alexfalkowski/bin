.PHONY: vendor

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

# Setup go deps.
dep: download tidy vendor

# Lint all the go code.
lint:
	golangci-lint run --timeout 5m

# Fix the lint issues in the go code (if possible).
fix-lint:
	golangci-lint run --timeout 5m --fix

# Run specs.
specs:
	go test -race -mod vendor -failfast -covermode=atomic -coverpkg=./... -coverprofile=test/reports/profile.cov ./...

remove-generated-coverage:
	cat test/reports/profile.cov | grep -v "test" > test/reports/final.cov

# Get the HTML coverage for go.
html-coverage: remove-generated-coverage
	go tool cover -html test/reports/final.cov

# Get the func coverage for go
func-coverage: remove-generated-coverage
	go tool cover -func test/reports/final.cov

# Send coveralls data.
goveralls: remove-generated-coverage
	goveralls -coverprofile=test/reports/final.cov -service=circle-ci -repotoken=${COVERALLS_REPO_TOKEN}

# Run security checks.
sec:
	bin/build/sec/go

# Update go dep.
update-dep: get tidy vendor

# Update all go dep.
update-all-deps: get-all tidy vendor

# Clean the reports.
clean-reports:
	rm -rf test/reports/*.*

# Encode a config.
encode-config:
	cat test/$(kind).yml | base64

# Start the environment.
start:
	bin/build/docker/env start

# Stop the environment.
stop:
	bin/build/docker/env stop
