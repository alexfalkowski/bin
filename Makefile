include build/make/help.mak
include build/make/ruby.mak
include build/make/git.mak

# Lint all scripts.
scripts-lint:
	@shellcheck build/docker/build build/docker/env build/docker/push build/docker/manifest build/sec/* build/go/clean quality/go/covfilter quality/ruby/feature quality/ruby/benchmark

# Lint all docker files.
docker-lint:
	@hadolint build/docker/go/Dockerfile
