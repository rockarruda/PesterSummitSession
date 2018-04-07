#Dot source private functions.
Get-ChildItem -Path $PSScriptRoot\functions\private\*.ps1 | ForEach-Object{ . $_.FullName }
#Dot source publis functions.
Get-ChildItem -Path $PSScriptRoot\functions\public\*.ps1 | ForEach-Object{ . $_.FullName }