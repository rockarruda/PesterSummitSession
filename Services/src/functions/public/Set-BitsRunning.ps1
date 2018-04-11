#Require -RunasAdministrator
#Requires -RunAsAdministrator
function Set-BitsRunning
{
    $BitsStatus = Get-Bits
    if ($BitsStatus.Status -eq 'Stopped')
    {
        Set-Service -Name BITS -Status Running -PassThru
    }
    else 
    {
        Write-Output "Bits service is already running"    
    }
    
}