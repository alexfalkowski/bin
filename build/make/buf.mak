NAME:=$(shell basename $(shell dirname $(CURDIR)))

# Lint protobuf definitions with buf.
lint:
	@buf lint

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

# Push module to the Buf Schema Registry (buf push).
push:
	@buf push

# Check for breaking API changes against master (subdir=api).
breaking:
	@buf breaking --against 'https://github.com/alexfalkowski/$(NAME).git#branch=master,subdir=api'
