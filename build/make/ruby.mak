.PHONY: vendor features

# Lint all the ruby code.
lint:
	bundle exec rubocop

# Fix linting issues in the ruby code.
fix-lint:
	bundle exec rubocop -A

# Format code.
format:
	bundle exec rubocop -A

path:
	bundle config set path vendor/bundle

# Get ruby deps.
dep: path
	bundle check || bundle install

# Update all ruby deps.
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
	rm -rf reports/*.*

# Leave only coverage files.
leave-coverage:
	find reports ! -name '*.cov' -type f -exec rm -f {} +

# Update a gem.
update-dep:
	bundle update $(gem)
