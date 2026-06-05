include build/make/help.mak
include build/make/ruby.mak
include build/make/git.mak

# Lint all scripts.
scripts-lint:
	@quality/shell/lint

# Lint all docker files.
docker-lint:
	@hadolint build/docker/go/Dockerfile

# Scan for security issues.
sec-lint:
	@build/sec/trivy-repo
