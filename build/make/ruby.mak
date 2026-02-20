.PHONY: vendor features

# Lint Ruby code with RuboCop.
lint:
	@bundler exec rubocop

# Auto-correct RuboCop offenses (safe + unsafe, RuboCop -A).
fix-lint:
	@bundler exec rubocop -A

# Format Ruby by applying RuboCop auto-corrections (RuboCop -A).
format:
	@bundler exec rubocop -A

path:
	@bundler config set path vendor/bundle

# Install gem dependencies into vendor/bundle (bundler install).
dep: path
	@bundler check || bundler install

# Update a single gem (set gem=<name>).
update-dep: path
	@bundler update $(gem)

# Update all gems (bundler update --all).
update-all-dep: path
	@bundler update --all

# Remove unused gems from vendor/bundle (bundler clean).
clean-dep: path
	@bundler clean

# List outdated explicit gems (bundler outdated --parseable).
outdated-dep: path
	@bundler outdated --only-explicit --strict --parseable

# Update the bundler gem.
update-bundler: path
	@bundler update --bundler

# Run cucumber features (feature=<path> optional; excludes @benchmark; tags=<expr> optional).
features:
	@$(PWD)/bin/quality/ruby/feature $(feature) $(tags)

# Run cucumber benchmarks (features tagged @benchmark; feature=<path> optional).
benchmarks:
	@$(PWD)/bin/quality/ruby/benchmark $(feature)

# Remove generated report artifacts under test/reports/.
clean-reports:
	@rm -rf test/reports/*.*

# Upload test/reports/coverage.xml to Codecov (codecovcli upload-process).
codecov-upload:
	@codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/coverage.xml

# Report code statistics with scc.
money:
	@scc --no-duplicates --no-min-gen

# Start shared docker environment via the sibling ../docker repo.
start:
	@$(PWD)/bin/build/docker/env start

# Stop shared docker environment via the sibling ../docker repo.
stop:
	@$(PWD)/bin/build/docker/env stop
