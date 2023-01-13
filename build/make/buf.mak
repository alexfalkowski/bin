# Lint buf.
buf-lint:
	buf lint

# Format buf.
buf-format:
	buf format -w

# Update all of buf deps.
buf-update-all:
	buf mod update

# Generate buf.
buf-generate:
	buf generate
