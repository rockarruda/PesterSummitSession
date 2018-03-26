. .\Get-Fax.ps1
Describe -Name 'TestFax' -Tag Fax{
    #Testing the function Get-Bits
    Context -Name 'Get-Fax'{
        It "Should Return Fax"{
            $Bits = Get-Fax
            $Bits.name | Should be 'fax'
        }
    }
}