# Dirs (-d flag)
$homeDir = "\\wsl$\Ubuntu-20.04\home\mjhammer\";
$reposDir = "$homeDir\repos";
$frontendDir = "$reposDir\frontend";

# Instance types (-p flag)
$ubuntu = "Ubuntu-20.04";
$commandPrompt = "Command Prompt";
$powershell = "Windows Powershell";

$homeTab = "-p  $ubuntu -d $frontendDir";
$frontendPane1 = "split-pane -V -p $ubuntu -d $frontendDir";
$frontendPane2 = "split-pane -H -p $ubuntu -d $frontendDir";

# All windows in one
$frontendWindows = "$homeTab;$frontendPane1;$frontendPane2;";

# Exta tabs
$frontendTab = "new-tab $frontendWindows; new-tab $homeTab";

# Open windows terminal with windows/tabs/panes.
start wt "$frontendWindows;$frontendTab";

