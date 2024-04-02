BRANCH:=$(shell git branch --show-current)
PREFIX:=$(shell ruby -e '_, t, n = ARGV[0].split("/"); print "#{t}(#{n}):" unless t.nil?' $(BRANCH))

master:
	git checkout master

pull:
	git pull --rebase

add:
	git add -A

# Reset the recent changes.
reset:
	git reset HEAD --hard && git clean -fd

# Undo the recent changes.
undo:
	git reset HEAD~1 --soft

# Get the latest submodule changes.
submodule:
	git submodule sync && git submodule update --init

new-branch: master pull
	git checkout -b "$(USER)/$(branch)"

# Start a new feature.
new-feature: branch="feat/$(name)"
new-feature: new-branch

# Start a new fix.
new-fix: branch="fix/$(name)"
new-fix: new-branch

# Start a new build.
new-build: branch="build/$(name)"
new-build: new-branch

# Start a new test.
new-test: branch="test/$(name)"
new-test: new-branch

# Finish the current chane.
done: master pull
	git branch -D $(BRANCH)

# Sync the current change.
sync:
	git fetch && git rebase origin/master

# Amend the latest changes.
amend: add
	git commit --amend --no-edit

# Commit the latest changes.
commit: add
	git commit -am "$(PREFIX) $(msg)"

# Push the latest changes.
push:
	git push -f origin $(BRANCH)

# Create a PR from the current change.
review:
	gh pr create -a @me --fill-first
