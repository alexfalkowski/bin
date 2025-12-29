.PHONY: status

USER:=$(shell echo "`whoami`-$$RANDOM")
BRANCH:=$(shell git branch --show-current)
NEW_BRANCH:=$(subst $() ,-,$(name))
PREFIX:=$(shell ruby -e '_, t, n = (ARGV[0] || "").split("/"); print "#{t}(#{n}):" unless t.nil?' $(BRANCH))

# Checkout master.
master:
	@git checkout master

# Pull changes.
pull:
	@git pull --rebase

# Add all files.
add:
	@git add -A

# Reset the recent changes.
reset:
	@git reset HEAD --hard && git clean -fd

# Undo the recent changes.
undo:
	@git reset HEAD~1 --soft

# Get the latest submodule changes.
submodule:
	@git submodule sync && git submodule update --init

# Update to the latest submodule changes.
update-submodule:
	@git submodule foreach git pull origin master

# Populate the branch.
branch:
	@echo "bin: current branch '$(BRANCH)'"

# Checkout branch.
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

# Start with docs.
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

# Delete docs.
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

# Finish the current change.
done: branch latest delete
	@echo "bin: done with branch '$(BRANCH)'"

# Sync the current change.
sync:
	@git fetch && git rebase origin/master

# Amend the latest changes.
amend: add
	@git commit --amend --no-edit

# Amend the latest changes for edit.
edit-amend: add
	@git commit --amend

# Commit the latest changes.
commit: add
	@git commit -a -m "$(PREFIX) $(msg)" -m "$(desc)"

# Push the latest changes.
push:
	@git push -f origin $(BRANCH)

# Create a draft PR from the current change.
draft:
	@gh pr create -d -a @me --fill-first --head $(BRANCH)

# Create a PR from the current change.
pr:
	@gh pr create -a @me --fill-first --head $(BRANCH)

# Create an auto merge.
merge:
	@gh pr merge --auto --squash

# Review the PR.
review: commit push draft

# The PR is ready to be merged.
ready: commit push pr merge

# Latest changes from master.
latest: master pull submodule

# The current changes.
current:
	@git diff

# The current status.
status:
	@git status

# The last changes.
last:
	@git log -p -1

# Stash changes.
stash: add
	@git stash

# Unstash changes.
unstash:
	@git stash pop

# Generates a sha256 sum of all files in git.
source-key:
	@git ls-files | grep -v bin | xargs sha256sum | cut -d" " -f1 | sha256sum | cut -d" " -f1 > .source-key

# Purge all branches.
purge:
	@git branch | grep -v "master" | xargs git branch -D
