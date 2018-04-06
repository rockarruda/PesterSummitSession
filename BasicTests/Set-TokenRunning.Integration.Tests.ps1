#Requires -RunAsAdministrator
. .\Get-Token.ps1
. .\Set-TokenRunning.ps1

Describe -Name 'SetToken' {

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
        
        It "Should Return Already Blazing" {
            $ServiceStatus = Set-TokenRunning
            $ServiceStatus | Should -Be "Token service is already Blazing"
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

        It "Should Start Service"{
            $SetStatus = Set-TokenRunning   
            $SetStatus.status | Should -Be "Running"  
        }
    }
    #Assert-VerifiableMock
}