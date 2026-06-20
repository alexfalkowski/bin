include $(dir $(lastword $(MAKEFILE_LIST)))_service.mak

# Lint Go and Ruby test harness.
lint: go-lint ruby-lint

# Auto-fix lint issues in Go and Ruby test harness (best effort).
fix-lint: go-fix-lint ruby-fix-lint

# Format Go and Ruby.
format: go-format ruby-format

# Open pprof for a captured profile under test/reports/ (set id/kind).
pprof:
	@$(BIN_ROOT)/quality/go/pprof "$${NAME}-server-$${id}-$${kind}.prof" id kind

# Update all Go modules and test/ gems.
update-all-dep: go-update-all-dep go-dep ruby-update-all-dep ruby-dep

# Run in dev mode with air; builds and runs "$(NAME) server" using test config.
dev:
	@$(BIN_ROOT)/build/go/dev "$${NAME}"
