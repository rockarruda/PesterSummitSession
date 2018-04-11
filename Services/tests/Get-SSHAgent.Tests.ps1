
Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force

InModuleScope Services {
    Describe -Name 'TestSSHAgent' -Tag SSH{
        #Testing the function Get-Bits
        Context -Name 'Get-SSHAgent'{
            It "Should Return SSHAgent"{
                $SSH = Get-SSHAgent
                $SSH.name | Should be 'ssh-agent'
            }
        }
    }
}