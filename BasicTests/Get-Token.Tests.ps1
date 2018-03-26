. .\Get-Token.ps1
Describe -Name 'TestToken' -Tag Bits{
    #Testing the function Get-Bits
    Context -Name 'Get-Token' {
        It "Should Return Bits"{
            $Bits = Get-Token
            $Bits.name | Should be 'tokenbroker'
        }
    }
}