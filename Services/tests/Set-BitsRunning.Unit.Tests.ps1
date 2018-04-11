#Requires -RunAsAdministrator

Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force

InModuleScope Services {
    Describe -Name 'SetBits' -Tag 'Unit' {

        Mock Set-Service -Verifiable -MockWith {
            return @{
                Status = 'Running'
                Name = 'BITS'
                DisplayName = 'Background Intelligent Transfer Service'
            }
        }

        #Checking Service is stopped
        Context -Name 'Service Running' {

            Mock Get-Service -Verifiable -MockWith {
                return @{
                    Status = 'Running'
                    Name = 'BITS'
                    Displayname = 'Background Intelligent Transfer Service'
                }
            }
        
            It "Should Return Already Running" {
                $ServiceStatus = Set-BitsRunning
                $ServiceStatus | Should -Be "Bits service is already running"
            }
        }
    
        Context -Name 'Service Stopped' {

            Mock Get-Service -Verifiable -MockWith {
                return @{
                    Status = 'Stopped'
                    Name = 'BITS'
                    Displayname = 'Background Intelligent Transfer Service'
                }
            }

            It "Should Start Service"{
                $SetStatus = Set-BitsRunning   
                $SetStatus.status | Should -Be "Running"  
            }
        }
        Assert-VerifiableMock
    }
}