#Requires -RunasAdministrator
#Hello, I hope this is going well so far
function Set-SSHRunning
{
    $SSHStatus = Get-SSHAgent
    if ($SSHStatus.Status -eq 'Stopped')
    {
        Set-Service -Name ssh-agent -Status Running -PassThru
    }
    else 
    {
        Write-Output "ssh-agent service is already running"    
    }
    
}