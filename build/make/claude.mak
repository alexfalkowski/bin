.PHONY: claude-init

BIN_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../..)

# Wire this repository for Claude Code using the shared bin skills.
# Creates a `.claude/skills` symlink and a managed `CLAUDE.md` import block.
claude-init:
	@BIN_ROOT="$(BIN_ROOT)" "$(BIN_ROOT)/build/claude/init"
