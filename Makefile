include build/make/help.mak
include build/make/ruby.mak
include build/make/git.mak

# Lint all scripts.
scripts-lint:
	@quality/shell/lint

# Lint shared skill policy markers.
skills-lint:
	@quality/skills/lint

# Lint all docker files.
docker-lint:
	@hadolint build/docker/go/Dockerfile
