#Requires -RunasAdministrator
#. .\Get-Token.ps1
function Set-TokenRunning
{
    $BitsStatus = Get-Token
    if ($BitsStatus.Status -eq 'Stopped')
    {
        Set-Service -Name TokenBroker -Status Running -PassThru
    }
    else 
    {
        Write-Output "Token service is already Running"    
    }
    
}