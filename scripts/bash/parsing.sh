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