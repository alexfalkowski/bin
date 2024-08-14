.PHONY: vendor features

# Lint all the the code.
lint:
	bundle exec rubocop

# Fix linting issues in the the code.
fix-lint:
	bundle exec rubocop -A

# Format code.
format:
	bundle exec rubocop -A

path:
	bundle config set path vendor/bundle

# Get the deps.
dep: path
	bundle check || bundle install

# Update a gem.
update-dep:
	bundle update $(gem)

# Update all the deps.
update-all-dep: path
	bundle update

# List outdated deps.
outdated-dep:
	bundle outdated --only-explicit --strict --parseable

# Run all features.
features:
	$(PWD)/bin/quality/ruby/cucumber $(feature) $(tags)

# Clean the reports.
clean-reports:
	rm -rf test/reports/*.*

# Leave only coverage files.
leave-coverage:
	find test/reports ! -name '*.cov' -type f -exec rm -f {} +

# Upload codecov information.
codecov-upload:
	codecovcli --verbose upload-process --fail-on-error -F service -f test/reports/coverage.xml
