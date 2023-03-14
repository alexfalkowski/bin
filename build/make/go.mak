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
	go test -race -mod vendor -failfast -covermode=atomic -coverpkg=./... -coverprofile=test/profile.cov ./...

remove-generated-coverage:
	cat test/profile.cov | grep -v "test" > test/final.cov

# Get the HTML coverage for go.
html-coverage: remove-generated-coverage
	go tool cover -html test/final.cov

# Get the func coverage for go
func-coverage: remove-generated-coverage
	go tool cover -func test/final.cov

# Update go dep.
update-dep: get tidy vendor

# Update all go dep.
update-all-deps: get-all tidy vendor
