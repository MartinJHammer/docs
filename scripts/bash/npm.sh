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
    npm start;
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