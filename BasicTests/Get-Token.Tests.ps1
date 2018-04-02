. .\Get-Token.ps1
Describe -Name 'TestToken' -Tag Bits{
    #Testing the function Get-Bits
    Context -Name 'Get-Token' {
        Mock Get-Token {return @{Name = "tokenbroker"}}
        It "Should Return Token"{
            $Token = Get-Token
            $Token.name | Should be 'tokenbroker'
        }
    }
}