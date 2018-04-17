<#
I call this the foundation block, where you can load modules or scripts into memory for purposes of running
your tests.#>
. .\Get-Token.ps1

Describe -Name 'TestToken' -Tag 'Unit'{ #This is the describe block which contains a group of tests, and you can also set a 
    #tag for ex.. Unit or integrated.
    #Testing the function Get-Token
    Context -Name 'Get-Token' { #This block is used to group a set of tests (It blocks) in the decribe block, 
        #use case would be scenarios etc..
        
        It "Should Return Token"{ #The It block is the test itself and validates the assertion
            $Token = Get-Token
            $Token.name | Should <#Command used to compare objects to be true of false#> be 'tokenbroker'
        }
    }
}