clear;
$root = "$env:USERPROFILE\Repos\plop-tns-app\tns-app";
$node_modules_installed = test-path "$root\node_modules";

if(-not $node_modules_installed) {
    write-host "`n";
    write-host "NPM packages not installed --> running npm i";
    write-host "`n";

    cd $root;
    npm i;
} 

# Run code
cd $root;
code .;

# Run emulator
cd $root;
