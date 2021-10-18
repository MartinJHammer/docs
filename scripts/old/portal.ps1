clear;

# Run api
powerShell -file './plop-api.ps1';

# Base vars
$reposRoot = "$env:USERPROFILE\Repos";

# Run web
$webRoot = "$reposRoot\plop-web";

cd $webRoot;
code .;
nps portal;