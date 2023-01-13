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
