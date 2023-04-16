.PHONY: vendor features

# Setup all needed.
setup: setup-bundler

setup-bundler:
	gem install bundler
	bundle config set path 'vendor/bundle'

# Lint all the ruby code.
lint:
	bundle exec rubocop

# Fix linting issues in the ruby code.
fix-lint:
	bundle exec rubocop -A

# Get ruby deps.
dep:
	bundle check || bundle install
	bundle clean --force

# Update all ruby deps.
update-all:
	bundle update

# Run all features.
features:
	bundle exec cucumber --profile report --fail-fast $(feature)

# Clean the reports.
clean-reports:
	rm -rf reports/*.*

# Update a gem.
update-dep:
	bundle update $(gem)
	bundle clean --force
