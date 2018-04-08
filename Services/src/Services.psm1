#Dot source private functions.
Get-ChildItem -Path $PSScriptRoot\Functions\Private\*.ps1 | ForEach-Object{ . $_.FullName }
#Dot source publis functions.
Get-ChildItem -Path $PSScriptRoot\Functions\Public\*.ps1 | ForEach-Object{ . $_.FullName }