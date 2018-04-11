
#Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force
. .\Get-Token.ps1

    Describe -Name 'TestToken' -Tag Bits{
        #Testing the function Get-Token
        Context -Name 'Get-Token' {
            #Mock line is commented out to show code coverage, once uncommented code coverage of my function`
            #will be 0% proving the mock is working.
            Mock Get-Token {return @{Name = "tokenbroker"}}
            It "Should Return TokenBroker"{
                $Token = Get-Token
                $Token.name | Should be 'tokenbroker'
            }
        }
    }
