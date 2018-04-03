<#
I call this the foundation block, where you can load modules or scripts into memory for purposes of running
your tests.
. .\Get-Token.ps1

#>
Describe -Name 'TestToken' -Tag Bits{ #This is the describe block which names the test, and you can also set a tag ex.. Unit or integrated.
    #Testing the function Get-Bits
    Context -Name 'Get-Token' { #This block is used to group a set of tests in the decribe block, use case would be scenarios etc..
        Mock Get-Token {return @{Name = "tokenbroker"}}
 WD       It "Should Return Token"{ #The It block is the test itself
            $Token = Get-Token
            $Token.name | Should <#Command used to compare objects#> be 'tokenbroker'
        }
    }
}