push() {
    git push
}

pull() {
    git pull
}

branch() {
    git branch --all | grep -i "$1"
}

delete() {
    git branch -D "$1";
    git push --delete origin "$1";
}

gitstatus() {
    echo -e "Fetching changes...\n"
    git fetch >/dev/null;
    git status;
    echo -e "\nContinues in 2...\n"
}

## Log local branches
b() {
    git branch
}

## Show git status
s() {
    git status
}

## Merge master
mm() {
    git fetch origin master:master
    git merge master
}


log() {
    # sed '/renovate/,+2d' = Remove 2 lines AFTER a line IF it contains renovate.
    # grep -v "renovate" = Filter away lines that contains renovate.
    # grep -v -P -A 1 "$searchword" = highlight word
    
    git log --author=${1:-"Martin Jul Hammer"} -v --since=1.weeks --pretty=format:"%cn: %s%nSHA: %H%n" | sed '/renovate/,+2d' | grep -v "renovate" | grep -v -P -A 1 "${2:-"default"}"
}

## Create new branch based on up-to-date master
nb() {
    git checkout master
    git pull
    git checkout -b "$1"
    git push --set-upstream origin "$1"
}

## Removes empty git objects from git .git/objects
fixgit() {
    find .git/objects/ -size 0 -exec rm -f {} \;
}

## Checkout local branch via number
co() {
    # https://bit.ly/2S54XNe <-- How to work with git in bash scripts
    # Prep

    get_branches () {
        git branch --format='%(refname:short)'
    }

    logBranchWithNumber () {
        index=$((${1}+1))
        branch=${2}
        echo "$index: $branch"
    }

    checkoutBranchAtTargetIndex () {
        index=${1}

        if [[ $index -eq $targetIndex ]]
        then
            branch=${2}
            git checkout $branch
        fi
    }

    master_first

    # Execute
    echo "Write branch number to checkout"
    mapfile -t -C logBranchWithNumber -c 1 < <( get_branches )
    read target;
    targetIndex=$(($target-1));
    mapfile -t -C checkoutBranchAtTargetIndex -c 1 < <( get_branches )
}

## Prune local list of remote branches 
prune() {
    git remote update origin --prune
}

## Logs local branches that has no remote.
## Deletes local branchs w.o. remote if -d is passed.
## Also prunes remote branches.
clean() {
    prune
    if [[ $1 == "-d" ]]
    then
        echo "DELETING branches w.o. a remote!"
        git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
    else
        echo "Branches w.o. a remote:"
        git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}'
    fi
}
