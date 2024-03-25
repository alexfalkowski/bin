NAME:=$(shell basename $(shell dirname $(CURDIR)))

# Lint buf.
lint:
	buf lint

# Format buf.
format:
	buf format -w

# Update all of buf deps.
update-all:
	buf mod update

# Generate buf.
generate:
	buf generate

# Push buf to repository.
push:
	buf push

# Buf breaking changes.
breaking:
	buf breaking --against 'https://github.com/alexfalkowski/$(NAME).git#branch=master,subdir=api'
