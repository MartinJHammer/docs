# Git commands

## HEAD
@ *// Alias for HEAD* \
HEAD *// Current commit* \
HEAD~ *// Previous commit* \
HEAD~1 *// Two commits back* \
HEAD~2 *// Three commits back, etc.* \
HEAD@{3} *// Refer to specific git action. Use git reflog to see what is what. Can also reset "forward"*

## Frequent commands
**Undo specific commit** \
git revert -n f0952ab780d1ee58627cddbaaff9356979856b7c \
git revert f0952ab780d1ee58627cddbaaff9356979856b7c

**Pull OTHER branch w.o checking out** \
git fetch origin master:master

**Update git** \
git update-git-for-windows

**Branch from commit** \
git branch <branchname> <sha1-of-commit>

**Publish additional branch** \
git push -u origin <branch-name>

**Delete local and remote branch** \
git push -d origin dev-mjh \
git branch -d dev-mjh

**Prune branches** \
git remote update origin --prune

**Get remote branch** \
git checkout --track origin/**

**Untrack file**
git rm --cached <file> \
git rm --cached <folder> -r

**New branch from commit** \
git checkout -b branchname 4e88815 <sha1-of-commit or HEAD~3> \
git branch branchname <sha1-of-commit>

**Undo last commit** \
git reset --hard HEAD^ \
git push origin -f

**See remote url** \
git config --get remote.origin.url

**Untrack all files** \
git rm --cached -r -A \
git rm --cached foo.txt

**Semi-automatic squash commits - `git push --force-with-lease` to update remote** \
git checkout <feature-branch> \
git reset $(git merge-base master $(git branch --show-current)) \
git add -A \
git commit -m "" \
git push --force-with-lease

**Remove untracked file** \
git clean -f

**Force push w.o. overwriting if others pushed** \
git push --force-with-lease

**Work in playground** \
git switch --detach

## git log
git log *// Logs commits* \
git log --oneline *// Logs commit w. one line* \
git log -g --invert-grep --grep='renovate' *// Include all commits that DOES NOT have 'renovate'* \
git log --author=Ionut --pretty=format:"%cn: %s%nSHA: %H%n"  *// See full list here:*
- https://bit.ly/2WK9jvu
- %s = Commit message aka refname
- %n = newline
- %cn = Comitter name
- %an = Author name
- %H = Full sha
- %h = Abbr sha
- %cd = Commit Date
- %d = refname

## git reset + reflog
git reflog *// List all reference logs. Note: ref = ponter to a commit.* \
git reflog @{2.minutes.ago} *// Set limit* \
git reset --soft \
git reset (--mixed) *// Undo last commit and put those changes in the working directory. Pass in HEAD~ to undo last commit* \
git reset --hard *// Undo all changes to working and staged tree. Pass in HEAD~ to undo last commit.* \
git reset HEAD@{3} *// Reset to specific ref. Use `git reflog` to see possabilities. *

**Remove specific commit from branch**
git rebase -p --onto SHA^ SHA

## git amend
git --amend -m "" *// Rename previous commit* \
git --amend -a --no-edit *// Add changes to previous commit*

## git stash
git stash *// stashes current TRACKED file changes* \
git stash -u *// stashes current tracked AND untracked file changes* \
git stash save "" *// stash changes with a custom description* \
git stash list *// List all stashes* \
git stash pop *// Reapply first stash item and removes it* \
git stash pop stash@{2} *// Reapply specific stash and remove it* \
git stash apply *// Reapply first stash item and keep it* \
git stash apply stash@{2} *// Reapply specific stash and keep it* \
git stash show *// File level diff* \
git stash show -p *// Full diff* \
git stash branch <name> stash@{1} *// Create branch from stash* \
git stash drop stash@{1} *// Drop stash* \
git stash clear *// Remove ALL stashes*

## Configuration commands
git config --global user.name "Martin" \
git config --global user.name \
git config --global user.email "martin_hammer@live.dk" \
git config --global user.email \
git config --global core.editor "Sublime.exe -wl1" \
git config --global color.ui true \
git config --global credential.helper wincred