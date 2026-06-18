NAME:=$(shell basename $(shell dirname $(CURDIR)))

# Lint protobuf definitions with buf.
lint: format-check
	@buf lint

# Check protobuf formatting without rewriting files.
format-check:
	@buf format --diff --exit-code

# Fix protobuf formatting by rewriting files in place (buf format -w).
fix-lint:
	@buf format -w

# Format protobuf files in place (buf format -w).
format:
	@buf format -w

# Update buf module deps (buf dep update + buf dep prune).
update-all-dep:
	@buf dep update && buf dep prune

# Generate code from protobufs (buf generate).
generate:
	@buf generate

# Regenerate protobuf outputs, then fail if git diff finds stale generated files.
stale: generate
	@git diff --exit-code

# Push module to the Buf Schema Registry (buf push).
push:
	@buf push

# Check for breaking API changes against master (subdir=api).
breaking:
	@buf breaking --against 'https://github.com/alexfalkowski/$(NAME).git#branch=master,subdir=api'
