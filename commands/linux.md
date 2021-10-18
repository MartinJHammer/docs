# Linux commands
cd
ls
mkdir
exec bash *restart console*
type <any-symbol> *see where something is*

## Add alias
printf "alias foo='bar'" >> ~/.bash_aliases

## Function in .bash_aliases
myfunction() {
    // anything
    // $1, $2
    // $@ <-- All passed arguments
}

test() {
    if [[ $1 == "-d" ]] # Use -eq for numbers
    then
        echo "DELETING"
    else
        echo "Just checking..."
    fi
}

## Read file contet
cat file.txt
less file.txt
top file.txt
tail file.txt

## Create and write to file
echo "test" > hello.txt
npm run test > test.txt

## Remove folde w. files fast!
rm -rf ./node_modules/

## Check ubuntu version
lsb_release -a

## Updgrade Ubuntu
sudo apt update
sudo apt -y upgrade

## Download files
wget www.some-site.com/my-pic.png

## See path for executable
which bash/wget/sh/python/etc.

## See all paths
echo $PATH

## Add file to global paths
sudo ln mySript.js /usr/local/bin/my_script

## Update global path permanently
nano ~/.bashrc
    export PATH="$HOME/mj-bin:$PATH"
source ~/.bashrc // Reload a file in the current session.

## DEBUG
DEBUG=<description>:* <command>