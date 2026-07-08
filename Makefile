include build/make/help.mak
include build/make/ruby.mak
include build/make/git.mak
include build/make/claude.mak
include build/make/codex.mak

# Lint Bash scripts under build/, quality/, and lib/ with ShellCheck.
scripts-lint:
	@quality/shell/lint

# Lint skill frontmatter, OpenAI metadata, and shared policy markers.
skills-lint:
	@quality/skills/lint

# Lint all docker files.
docker-lint:
	@hadolint build/docker/go/Dockerfile
