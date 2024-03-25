master:
	git checkout master

pull:
	git pull --rebase

add:
	git add -A

# Start a new feature, bug, etc.
new: master pull
	git checkout -b $(name)

# Finish a the feature, bug, etc.
done: master pull
	git branch -D $(name)

# Sync the current feature, bug, etc.
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
	git push -f origin $(name)

# Commit and push
commit-push: commit push
