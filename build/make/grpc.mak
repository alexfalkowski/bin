include $(dir $(lastword $(MAKEFILE_LIST)))_service.mak

# Lint protobuf definitions in api/ with buf.
proto-lint:
	@make -C api lint

# Format protobuf files in api/ (buf format -w).
proto-fix-lint:
	@make -C api fix-lint

# Lint Go, Ruby test harness, and protobuf API.
lint: go-lint ruby-lint proto-lint

# Auto-fix lint issues in Go/Ruby/proto (best effort).
fix-lint: go-fix-lint ruby-fix-lint proto-fix-lint

# Format protobuf files in api/ (buf format -w).
proto-format:
	@make -C api format

# Format Go, Ruby, and protobuf files.
format: go-format ruby-format proto-format

# Detect breaking protobuf API changes against the remote master baseline.
proto-breaking:
	@make -C api breaking

# Generate code from api/ protobufs (buf generate).
proto-generate:
	@make -C api generate

# Regenerate api/ protobuf outputs, then fail if git diff finds stale files.
proto-stale:
	@make -C api stale

# Push the api/ module to the Buf Schema Registry (buf push).
proto-push:
	@make -C api push

# Open pprof for a captured profile under test/reports/ (set id/kind).
pprof:
	@$(BIN_ROOT)/quality/go/pprof "$${NAME}-server-$${id}-$${kind}.prof" id kind

# Update buf dependencies in api/ (buf dep update + prune).
proto-update-all-dep:
	@make -C api update-all-dep

# Update all Go modules, test/ gems, and api/ buf deps.
update-all-dep: go-update-all-dep go-dep ruby-update-all-dep ruby-dep proto-update-all-dep

# Run in dev mode with air; builds and runs "$(NAME) server" using test config.
dev:
	@air -c /dev/null --build.cmd "make dep build" --build.entrypoint "$(CURDIR)/$(NAME)" --build.args_bin "server,-config,file:test/.config/server.yml" --build.exclude_dir "assets,bin,vendor,test"
