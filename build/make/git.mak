.PHONY: status

BIN_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../..)

USER:=$(shell ruby -e 'require "etc"; print "#{Etc.getpwuid(Process.uid).name}-#{Random.rand(0...100_000)}"')
BRANCH:=$(shell git branch --show-current)
export BRANCH
NEW_BRANCH:=$(subst $() ,-,$(name))
PREFIX:=$(shell ruby -e '_, t, n = (ENV["BRANCH"] || "").split("/"); print "#{t}(#{n}):" unless t.nil?')
export PREFIX

override export msg := $(value msg)
override export desc := $(value desc)
override export desc_file := $(value desc_file)

# Checkout the master branch.
master:
	@git checkout master

# Pull latest changes with rebase.
pull:
	@git pull --rebase

# Fetch remote refs.
fetch:
	@git fetch origin

# Stage all changes (tracked + untracked).
add:
	@git add -A

# Discard local changes (hard reset + remove untracked files).
reset:
	@git reset HEAD --hard && git clean -fd

# Undo the last commit while keeping changes staged.
undo:
	@git reset HEAD~1 --soft

# Sync and initialize/update submodules.
submodule:
	@git submodule sync && git submodule update --init

# Pull latest master in each submodule.
update-submodule:
	@git submodule foreach git pull origin master

# Print the current git branch.
branch:
	@printf "bin: current branch '%s'\n" "$$BRANCH"

# Create and checkout username-random/$(branch).
checkout:
	@git checkout -b "$(USER)/$(branch)"

new-branch: latest checkout
	@echo "bin: new branch '$(USER)/$(branch)'"

# Start a new feature branch (name=<branch>, runs latest first).
new-feature: branch=feat/$(NEW_BRANCH)
new-feature: new-branch

# Start a new fix branch (name=<branch>, runs latest first).
new-fix: branch=fix/$(NEW_BRANCH)
new-fix: new-branch

# Start a new build branch (name=<branch>, runs latest first).
new-build: branch=build/$(NEW_BRANCH)
new-build: new-branch

# Start a new test branch (name=<branch>, runs latest first).
new-test: branch=test/$(NEW_BRANCH)
new-test: new-branch

# Start a new docs branch (name=<branch>, runs latest first).
new-docs: branch=docs/$(NEW_BRANCH)
new-docs: new-branch

# Start a new refactor branch (name=<branch>, runs latest first).
new-refactor: branch=refactor/$(NEW_BRANCH)
new-refactor: new-branch

# Start a new release branch (name=<branch>, runs latest first).
new-release: branch=release/$(NEW_BRANCH)
new-release: new-branch

# Delete the current branch.
delete:
	@git branch -D "$$BRANCH"

# Update from master and delete the current branch.
done: branch latest delete
	@printf "bin: done with branch '%s'\n" "$$BRANCH"

# Fetch remote refs, integrate the current remote branch when present, and
# rebase the current branch onto origin/master.
sync: fetch
	@$(BIN_ROOT)/build/git/sync

# Amend the last commit with staged changes (no message edit).
amend: add
	@git commit --amend --no-edit

# Amend the last commit with staged changes (edit message).
edit-amend: add
	@git commit --amend

# Commit all changes with a prefix derived from the branch (set msg and desc or desc_file).
commit: add
	@$(BIN_ROOT)/build/git/commit

# Force-push the current branch to origin when it still matches the fetched ref.
push:
	@$(BIN_ROOT)/build/git/push

# Amend the last commit and force-push with a lease.
force: amend push

# Create a draft PR for the current branch (gh pr create --draft).
draft:
	@gh pr create -d -a @me --fill-first --head "$$BRANCH"

# Create a PR for the current branch (gh pr create).
pr:
	@gh pr create -a @me --fill-first --head "$$BRANCH"

# Enable auto squash-merge for the current PR.
merge:
	@gh pr merge --auto --squash

# Commit, force-push with a lease, and open a draft PR.
review: commit push draft

# Commit, force-push with a lease, open PR, and enable auto-merge.
ready: commit push pr merge

# Checkout master, pull, and update submodules.
latest: master pull submodule

# Show the working tree diff.
current:
	@git diff

# Show repository status.
status:
	@git status

# Show the last commit (patch).
last:
	@git log -p -1

# Stash current changes (staging first).
stash: add
	@git stash

# Apply and drop the latest stash.
unstash:
	@git stash pop

# Generate a repo source key (sha256 of tracked files excluding bin/) into .source-key.
source-key:
	@git ls-files | grep -v '^bin/' | xargs sha256sum | cut -d" " -f1 | sha256sum | cut -d" " -f1 > .source-key

# Delete all local branches except master.
purge:
	@git branch | sed 's/^[* ]*//' | grep -vx 'master' | xargs git branch -D

# Delete remote ref and local tag for version=<tag>.
delete-version:
	@git push --delete origin $(version) && git tag -d $(version)

# Enable performance-related git settings and run git gc.
optimise:
	@$(BIN_ROOT)/build/git/optimise
