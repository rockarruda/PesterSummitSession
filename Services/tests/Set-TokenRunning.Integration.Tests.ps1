#Requires -RunAsAdministrator

Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force

InModuleScope Services {
    Describe -Name 'SetToken' -Tag 'Integration' {

        <#Mock Set-Service -Verifiable -MockWith {
        return @{
            Status = 'Running'
            Name = 'TokenBroker'
            Displayname = 'TokenBroker'
        }  
    }#>

    
        #Checking Service is stopped
        Context -Name 'Service Running' {

            <#Mock Get-Service -Verifiable -MockWith {
            return @{
                Status = 'Running'
                Name = 'TokenBroker'
                Displayname = 'TokenBroker'
            }
        }#>
        
            It "Should Return Already Running" {
                $ServiceStatus = Set-TokenRunning
                $ServiceStatus | Should -Be "Token service is already Running"
            }
        }
    
        Context -Name 'Service Stopped' {

            <#Mock Get-Service -Verifiable -MockWith {
            return @{
                Status = 'Stopped'
                Name = 'TokenBroker'
                Displayname = 'TokenBroker'
            }
        }#>

            It "Should Start Token Service"{
                Stop-Service -Name TokenBroker
                $SetStatus = Set-TokenRunning   
                $SetStatus.status | Should -Be "Running"  
            }
        }
        #Assert-VerifiableMock
    }
}