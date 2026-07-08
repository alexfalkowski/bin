.PHONY: codex-init

BIN_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../..)

# Wire this repository for Codex using the shared bin skills.
# Creates a `.agents/skills` symlink for repo-scoped `$skill` discovery.
codex-init:
	@BIN_ROOT="$(BIN_ROOT)" "$(BIN_ROOT)/build/codex/init"
