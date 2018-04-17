#Requires -RunasAdministrator

function Set-TokenRunning
{
    $TokenStatus = Get-Token
    if ($TokenStatus.Status -eq 'Stopped')
    {
        Set-Service -Name TokenBroker -Status Running -PassThru
    }
    else 
    {
        Write-Output "Token service is already running"    
    }
    
}