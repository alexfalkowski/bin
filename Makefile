include build/make/git.mak

# Lint all docker files.
docker-lint:
	hadolint build/docker/go/Dockerfile

# Lint everything.
lint: docker-lint
