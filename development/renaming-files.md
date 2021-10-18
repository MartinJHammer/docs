# Renaming files
some-file-name (match case + exact)
SomeFileName (match case + not exact)
some file name (no match case + not exact)

## Quick naming files

## Steps
1. Copy example of code to scaffold to files in the schematics folder.
2. Open a powershell window in the files folder.
3. Run the below command in the powershell window
    Get-ChildItem -recurse -name | ForEach-Object { Move-Item $_ $_.replace("user", "tenant") }
4. Open the files folder in VS code. 
5. If you have turned "editor.formatOnSave": true in vs code settings, turn this to false while replacing (only needed if you use <%= %> or other symbols).
6. ctrl + shift + h
7. Turn on 'MATCH CASE' - Turn off 'MATCH WHOLE WORD'
8. Search and replace (Remember to replace entity name before replacing Capital name)

## Words to replace (standard crud)
rate-plan
rate_plan
ratePlan
RatePlan
RATE_PLAN

Get-ChildItem -recurse -name | ForEach-Object { Move-Item $_ $_.replace("hello-world", "navigation-drawer") }