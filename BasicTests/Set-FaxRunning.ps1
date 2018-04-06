#Requires -RunasAdministrator
. .\Get-Fax.ps1
function Set-FaxRunning
{
    $BitsStatus = Get-Fax
    if ($BitsStatus.Status -eq 'Stopped')
    {
        Set-Service -Name fax -Status Running -PassThru
    }
    else 
    {
        Write-Output "Fax service is already running"    
    }
    
}