BRANCH=$(shell git branch --show-current)

master:
	git checkout master

pull:
	git pull --rebase

add:
	git add -A

# Start a new feature.
new-feature: master pull
	git checkout -b "feat/$(name)"

# Start a new fix.
new-fix: master pull
	git checkout -b "fix/$(name)"

# Start a new fix.
new-build: master pull
	git checkout -b "build/$(name)"

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
	git commit -am "$(msg)"

# Push the latest changes.
push:
	git push -f origin $(BRANCH)

# Commit and push
commit-push: commit push

# Sync and push
sync-push: sync push
