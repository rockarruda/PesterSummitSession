
#Import-Module "C:\github\PesterSummitSession\Services\src\Services.psd1" -Force
. .\Get-Bits.ps1

    Describe -Name 'TestBits' -Tag Bits {
        #Testing the function Get-Bits
        Context -Name 'Get-Bits' {
            It "Should Return Bits"{
                $Bits = Get-Bits
                $Bits.name | Should be 'bits'
            }
        }
    }
