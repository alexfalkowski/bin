.PHONY: status

USER:=$(shell ruby -e 'require "etc"; print "#{Etc.getpwuid(Process.uid).name}-#{Random.rand(0...100_000)}"')
BRANCH:=$(shell git branch --show-current)
NEW_BRANCH:=$(subst $() ,-,$(name))
PREFIX:=$(shell ruby -e '_, t, n = (ARGV[0] || "").split("/"); print "#{t}(#{n}):" unless t.nil?' $(BRANCH))

# Checkout the master branch.
master:
	@git checkout master

# Pull latest changes with rebase.
pull:
	@git pull --rebase

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
	@echo "bin: current branch '$(BRANCH)'"

# Create and checkout a new branch named $(USER)/$(branch).
checkout:
	@git checkout -b "$(USER)/$(branch)"

new-branch: latest checkout
	@echo "bin: new branch '$(USER)/$(branch)'"

# Start a new feature.
new-feature: branch=feat/$(NEW_BRANCH)
new-feature: new-branch

# Start a new fix.
new-fix: branch=fix/$(NEW_BRANCH)
new-fix: new-branch

# Start a new build.
new-build: branch=build/$(NEW_BRANCH)
new-build: new-branch

# Start a new test.
new-test: branch=test/$(NEW_BRANCH)
new-test: new-branch

# Start a new docs branch.
new-docs: branch=docs/$(NEW_BRANCH)
new-docs: new-branch

# Start with a refactor.
new-refactor: branch=refactor/$(NEW_BRANCH)
new-refactor: new-branch

# Start a new release.
new-release: branch=release/$(NEW_BRANCH)
new-release: new-branch

delete-branch: branch latest
	@git branch -D "$(USER)/$(branch)"

# Delete a feature.
delete-feature: branch=feat/$(NEW_BRANCH)
delete-feature: delete-branch

# Delete a fix.
delete-fix: branch=fix/$(NEW_BRANCH)
delete-fix: delete-branch

# Delete a build.
delete-build: branch=build/$(NEW_BRANCH)
delete-build: delete-branch

# Delete a test.
delete-test: branch=test/$(NEW_BRANCH)
delete-test: delete-branch

# Delete a docs branch.
delete-docs: branch=docs/$(NEW_BRANCH)
delete-docs: delete-branch

# Delete a refactor.
delete-refactor: branch=refactor/$(NEW_BRANCH)
delete-refactor: delete-branch

# Delete a release.
delete-release: branch=release/$(NEW_BRANCH)
delete-release: delete-branch

# Delete the current branch.
delete:
	@git branch -D $(BRANCH)

# Update from master and delete the current branch.
done: branch latest delete
	@echo "bin: done with branch '$(BRANCH)'"

# Rebase the current branch onto origin/master.
sync:
	@git fetch && git rebase origin/master

# Amend the last commit with staged changes (no message edit).
amend: add
	@git commit --amend --no-edit

# Amend the last commit with staged changes (edit message).
edit-amend: add
	@git commit --amend

# Commit all changes with a prefix derived from the branch (set msg/desc).
commit: add
	@git commit -a -m "$(PREFIX) $(msg)" -m "$(desc)"

# Force-push the current branch to origin.
push:
	@git push -f origin $(BRANCH)

# Create a draft PR for the current branch (gh pr create --draft).
draft:
	@gh pr create -d -a @me --fill-first --head $(BRANCH)

# Create a PR for the current branch (gh pr create).
pr:
	@gh pr create -a @me --fill-first --head $(BRANCH)

# Enable auto squash-merge for the current PR.
merge:
	@gh pr merge --auto --squash

# Commit, force-push, and open a draft PR.
review: commit push draft

# Commit, force-push, open PR, and enable auto-merge.
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
	@git ls-files | grep -v bin | xargs sha256sum | cut -d" " -f1 | sha256sum | cut -d" " -f1 > .source-key

# Delete all local branches except master.
purge:
	@git branch | grep -v "master" | xargs git branch -D

# Delete remote ref and local tag for version=<tag>.
delete-version:
	@git push --delete origin $(version) && git tag -d $(version)

# Enable performance-related git settings and run git gc.
optimise:
	@git config feature.manyFiles true
	@git update-index --index-version 4
	@git config core.fsmonitor true
	@git config core.untrackedcache true
	@git config core.commitgraph true
	@git config fetch.writeCommitGraph true
	@git gc
