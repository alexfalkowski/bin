NAME:=$(shell basename $(shell dirname $(CURDIR)))

# Lint buf.
lint:
	@buf lint

# Fix the lint issues in the proto code (if possible).
fix-lint:
	@buf format -w

# Format buf.
format:
	@buf format -w

# Update all of buf deps.
update-all-dep:
	@buf mod update && buf mod prune

# Generate buf.
generate:
	@buf generate

# Push buf to repository.
push:
	@buf push

# Buf breaking changes.
breaking:
	@buf breaking --against 'https://github.com/alexfalkowski/$(NAME).git#branch=master,subdir=api'
