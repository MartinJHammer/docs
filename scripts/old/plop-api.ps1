# Base vars
$reposRoot = "$env:USERPROFILE\Repos";

# plop-api vars
$apiRoot =  "$reposRoot\plop-api";
$apiToolsFolder = "$apiRoot\tools";

# plop-requests-execution vars
$requestExecutionRoot =  "$reposRoot\plop-requests-execution";
$requestExecutionToolsFolder = "$requestExecutionRoot\tools";

# Run http-requests
cd $requestExecutionToolsFolder;
write-host "Starting pubsub";
start-process "$requestExecutionToolsFolder\run-pubsub-developer.bat";

# Run plop-api internal apis
cd $apiToolsFolder;
write-host "Starting database api";
start-process "$apiToolsFolder\run-databases-api.bat";
write-host "Starting tasks";
start-process "$apiToolsFolder\run-tasks-service.bat";
write-host "Starting portal api";
start-process "$apiToolsFolder\run-portal-api.bat";