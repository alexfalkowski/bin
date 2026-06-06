include $(dir $(lastword $(MAKEFILE_LIST)))_service.mak

override export cmd := $(value cmd)

# Lint Go and Ruby test harness.
lint: go-lint ruby-lint

# Auto-fix lint issues in Go and Ruby test harness (best effort).
fix-lint: go-fix-lint ruby-fix-lint

# Format Go and Ruby.
format: go-format ruby-format

# Open pprof for a captured profile under test/reports/ (set cmd/id/kind).
pprof:
	@$(BIN_ROOT)/quality/go/pprof "$${NAME}-$${cmd}-$${id}-$${kind}.prof" cmd id kind

# Update all Go modules and test/ gems.
update-all-dep: go-update-all-dep go-dep ruby-update-all-dep ruby-dep
