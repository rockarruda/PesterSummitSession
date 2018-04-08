#. .\Get-Fax.ps1
#. .\Set-FaxRunning.ps1
Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force
InModuleScope Services {
    Describe -Name 'SetFax' {

        Mock Set-Service -Verifiable -MockWith {
            return @{
                Status = 'Running'
                Name = 'Fax'
                DisplayName = 'fax'
            }
        }

        #Requires -RunAsAdministrator
        #Checking Service is stopped
        Context -Name 'Service Running' {

            Mock Get-Service -Verifiable -MockWith {
                return @{
                    Status = 'Running'
                    Name = 'Fax'
                    Displayname = 'fax'
                }
            }
        
            It "Should Return Already Running" {
                $ServiceStatus = Set-FaxRunning
                $ServiceStatus | Should -Be "Fax service is already running"
            }
        }
    
        Context -Name 'Service Stopped' {

            Mock Get-Service -Verifiable -MockWith {
                return @{
                    Status = 'Stopped'
                    Name = 'Fax'
                    Displayname = 'fax'
                }
            }

            It "Should Start Service"{
                $SetStatus = Set-FaxRunning   
                $SetStatus.status | Should -Be "Running"  
            }
        }
        Assert-VerifiableMock
    }
}