default: help

BIN_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../..)

# Print help by parsing target comments in the current Makefiles.
help:
	@cat $(MAKEFILE_LIST) | $(BIN_ROOT)/build/help/print
