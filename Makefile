include build/make/help.mak
include build/make/ruby.mak
include build/make/git.mak
include build/make/claude.mak
include build/make/codex.mak

# Lint Bash scripts under build/, quality/, lib/, and test/ with ShellCheck.
scripts-lint:
	@test/shell/lint

# Validate skill frontmatter, OpenAI metadata, and shared policy markers.
skills-lint:
	@test/skills/lint

# Lint all docker files.
docker-lint:
	@hadolint build/docker/go/Dockerfile
