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
lint: go-lint ruby-lint proto-lint proto-breaking

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

# Run all the features.
features: build-test
	make -C test features

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
