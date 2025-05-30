.PHONY: vendor features

# Lint all the the code.
lint:
	@bundler exec rubocop

# Fix linting issues in the the code.
fix-lint:
	@bundler exec rubocop -A

# Format code.
format:
	@bundler exec rubocop -A

path:
	@bundler config set path vendor/bundle

# Get the deps.
dep: path
	@bundler check || bundler install

# Update a gem.
update-dep: path
	@bundler update $(gem)

# Update all the deps.
update-all-dep: path
	@bundler update

# Clean all deps.
clean-dep: path
	@bundler clean

# List outdated deps.
outdated-dep: path
	@bundler outdated --only-explicit --strict --parseable

# Update bundler.
update-bundler: path
	@bundler update --bundler

# Run all features.
features:
	@$(PWD)/bin/quality/ruby/feature $(feature) $(tags)

# Run all benchmarks.
benchmarks:
	@$(PWD)/bin/quality/ruby/benchmark $(feature)

# Clean the reports.
clean-reports:
	@rm -rf test/reports/*.*

# Upload codecov information.
codecov-upload:
	@codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/coverage.xml
