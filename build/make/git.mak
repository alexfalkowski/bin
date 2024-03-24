master:
	git checkout master

pull:
	git pull --rebase

add:
	git add -A

# Start a new feature, bug, etc.
start: master pull
	git checkout -b $(name)

# Finish a the feature, bug, etc.
finish: master pull
	git brand -D $(name)

# Sync the current feature, bug, etc.
sync:
	git fetch && git rebase origin/master

# Amend the latest changes.
amend: add
	git commit --amend --no-edit

# Push the latest changes.
push:
	git push -f origin $(name)
