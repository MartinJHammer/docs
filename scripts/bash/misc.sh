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

myip() { 
    curl ipinfo.io/ip;
    echo "";
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