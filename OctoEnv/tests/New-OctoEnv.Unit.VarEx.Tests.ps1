#If you are reading this, remember don't laugh at my code!!  Comments are fine.. you can laugh at comments :-)
#   Param(
    
#          [Parameter(Mandatory)] 
#          [ValidateNotNullOrEmpty()]   
#          [String]$OctoEnvName

#      )
Import-Module "C:\github\PesterSummitSession\OctoEnv\src\OctoEnv.psd1" -Force


InModuleScope OctoEnv {

    # Param(
    
    #     [Parameter(Mandatory)] 
    #     [ValidateNotNullOrEmpty()]   
    #     [String]$OctoEnvName

    # )

    Describe -Name 'TestOctoEnv' -Tag 'Variable' {

   

        Context -Name 'Env already exists' {
            #Mocking the invoke-restmethod from Get-Octoenvnames which will jump to Env already exits.cd..
            Mock Invoke-RestMethod -Verifiable -MockWith {
        
                return [PSCustomObject]@{

                    Items = @{
                        Id = "Environments-99"
                        Name = "$OctoEnvName"
                        Description = "TestPost"
                    }
                }
    
            }
         
            It "Should return: $OctoEnvName environment exists" {
                $EnvName = New-OctoEnv -OctoEnvName $OctoEnvName
                $EnvName | Should -Be "$OctoEnvName already exists"
            }
        }

        Context -Name 'Env does not exist, create the env'{
            #Mocking the invoke restmethod of from the else block which would return the object it created.
            Mock Invoke-RestMethod -Verifiable -MockWith {
        
                return [PSCustomObject]@{
                    Id = "Environments-99"
                    Name = "$OctoEnvName"
                    Description = "TestPost"
                }
    
            }

            It "Should Create $OctoEnvName" {
                $CreateEnv = New-OctoEnv -OctoEnvName $OctoEnvName
                $CreateEnv.Name | Should -Be "$OctoEnvName"
            }
        }
    }
}
