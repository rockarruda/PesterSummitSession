#Requires -RunAsAdministrator

Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force

InModuleScope Services {
    Describe -Name 'SetSSHAgent' -Tag 'Integration' {

        <#Mock Set-Service -Verifiable -MockWith {
            return @{
                Status = 'Running'
                Name = 'ssh-agent'
                DisplayName = 'ssh-agent'
            }
        }#>

        #Checking Service is stopped
        Context -Name 'Service Running' {

            <#Mock Get-Service -Verifiable -MockWith {
                return @{
                    Status = 'Running'
                    Name = 'ssh-agent'
                    Displayname = 'ssh-agent'
                }
            }#>
        
            It "Should Return Already Running" {
                $ServiceStatus = Set-SSHRunning
                $ServiceStatus | Should -Be "ssh-agent service is already running"
            }
        }
    
        Context -Name 'Service Stopped' {

           <# Mock Get-Service -Verifiable -MockWith {
                return @{
                    Status = 'Stopped'
                    Name = 'ssh-agent'
                    Displayname = 'ssh-agent'
                }
            }#>

            It "Should Start Service"{
                Stop-Service -Name ssh-agent
                $SetStatus = Set-SSHRunning   
                $SetStatus.status | Should -Be "Running"  
            }
        }
        #Assert-VerifiableMock
    }
}