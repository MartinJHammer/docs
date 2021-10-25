adda() {
    code ~/scripts
}

## Refresh bash
eb() {
    exec bash
}

## Clear console
ca() {
    clear;
}

## Open VS Code
c() {
    code .;
}

## Kill port
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