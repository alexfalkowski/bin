.PHONY: codex-init

BIN_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../..)

# Wire this repository for Codex using shared skills, permissions, and rules.
# Creates `.agents/skills`, `.codex/config.toml`, and `.codex/rules/bin.rules` symlinks.
codex-init:
	@BIN_ROOT="$(BIN_ROOT)" "$(BIN_ROOT)/build/codex/init"
