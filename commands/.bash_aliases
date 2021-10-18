# Colors for pretty print
# Use "${GREEN}" at start of output to color. 
# Will stay "GREEN" until NO_COLOR is added.
RED='\033[0;31m'
GREEN='\033[0;32m';
NO_COLOR='\033[0m';

# Main
adda() {
    code ~/.bash_aliases
}

## Refresh bash
eb() {
    exec bash
}

ca() {
    clear;
}

aliases() {
    cat ~/.bash_aliases
}

# Misc
c() {
    code .;
}

kill() {
    if [[ -z $1 ]]
    then
        echo "killing port 4200";
        sudo kill -9 `sudo lsof -t -i:4200`;
    else
        echo "killing port $1"
        sudo kill -9 `sudo lsof -t -i:$1`;
    fi
}

npmlist() {
    npm -g list --depth=0;
}

nvmcheck() {
    # Use node version defined. Do not output anything.
    nvm use >/dev/null;
    
    # Set vars
    local nvmVersion=$(cat .nvmrc);
    local nodeVersion=$(node --version | sed "s/v//"); # remove the "v" from the string
    local trimmedNodeVersion=${nodeVersion:0:${#nvmVersion}}

    # Echo if we actually use the same node version as defined.
    if [ $nvmVersion = $trimmedNodeVersion ]
    then
        echo -e "\n${GREEN}Node version ($trimmedNodeVersion) matches .nvmrc version ($nvmVersion)${NO_COLOR}\n"
    else
        echo -e "\n${RED}========== !!! WARNING !!! ===========";
        echo "NODE VERSION ($trimmedNodeVersion) DOES NOT MATCH .nvmrc VERSION ($nvmVersion)";
        echo -e "========== !!! WARNING !!! ===========\n${NO_COLOR}";

        echo -e "\nAttempting to install newest node version and use that instead...\n"
        nvm install $nvmVersion;
    fi

    # Feel free to remove sleep.
    # Added to make sure message stays bit before additional output appears.
    sleep 1s; 
}

start() {
    gitdailystatus;
    nvmcheck;
    npm start;
}

myip() { 
    curl ipinfo.io/ip;
    echo "";
}

go() {
    cd;
    if [[ $1 == "r" ]]
    then 
        cd "./repos";
    elif [[ $1 == "d" ]]
    then
        cd "./repos/docs";
    else
        cd;
    fi
}

## Requires jq installed: sudo apt install jq
## Docs: https://stedolan.github.io/jq/manual/#Basicfilters
scripts() {
    if [[ $1 == "v" ]]
    then 
        ### List values
        jq '.scripts[]' package.json
    elif [[ $1 == "k" ]]
    then
        ### List keys
        jq '.scripts | keys' package.json
    else
        ### List object
        jq '.scripts' package.json
    fi
}

# Coms
comsup() {
    gitdailystatus;
    nvmcheck;
    docker-compose up postgres mongo minio
}

# Frontend
portal() {
    export FLATFILE_LICENSE_KEY_PROD=1bdcb3bc-1639-4f4e-85ab-4b96487a14e4;
    export FLATFILE_LICENSE_KEY_TEST=44f70bdb-cc44-42e8-8e63-d03ff1f31889;
    gitdailystatus;
    nvmcheck;
    npm run start:portal
}

## Removes node modules
rmn(){
    rm -rf ./node_modules
}

fixnpm() {
    echo "Starting..."
    nvmcheck;
    npm cache clean --force
    rmn;
    rm ./package-lock.json
    npm i
}

# Git
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

gitdailystatus() {
    if [ -z "$FETCHED_TODAY" ]; then
        export FETCHED_TODAY=true
        gitstatus
    fi
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

## Takes all folders in the current directory, pull changes and reinstall node modules.
updateall() {
    go g;
    ## Get all folders
    ## files=$(ls -t); # Output directory names
    tFolders=$(find ./* -maxdepth 0 -type d); # Output directory names with ./

    ## Pull changes and reinstall node modules
    pullAndInstall() {
        tFolder=$1;
        cd $tFolder;
        echo -e "\n==================";
        echo "STARTING WORK FOR $tFolder";
        echo "==================";
        git reset --hard;
        git clean -f;
        git checkout master;
        nvmcheck;
        rm package-lock.json;
        rmn;
        sleep 5s
        git fetch;
        git pull;
        npm i --legacy-peer-deps;
        git reset --hard;
        echo -e "\n==================================";
        echo "$tFolder: All done!!! 🥳🥳🥳"
        echo "==================================";
    }

    for tFolder in $tFolders; do
      (pullAndInstall "$tFolder") # () prevents extra output
        # (pullAndInstall "$tFolder" &) old syntax to start in new thread. Worked bad because of node versions changing foreach repo.
    done

    echo -e "\n==================================";
    echo "All projects updated!!! 🥳🥳🥳"
    echo -e "==================================\n\n";
    echo "...maybe restart your computer? 🤔";
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
