#If you are reading this, remember don't laugh at my code!!  Comments are fine.. you can laugh at comments :-)

Import-Module "C:\github\PesterSummitSession\OctoEnv\src\OctoEnv.psd1" -Force

InModuleScope OctoEnv {

    Describe -Name 'TestOctoEnv' -Tag 'Unit' {

        Context -Name 'EnvExists' {
            #Mocking the invoke-restmethod from Get-Octoenvnames which will jump to Env already exits.
            Mock Invoke-RestMethod -Verifiable -MockWith {
        
                return [PSCustomObject]@{

                    Items = @{
                        Id = "Environments-99"
                        Name = "Summit.Rocks"
                        Description = "TestPost"
                    }
                }
    
            }
         
            It 'Should return environment exists' {
                $EnvName = New-OctoEnv -OctoEnvName "Summit.Rocks"
                $EnvName | Should -Be "Summit.Rocks already exists"
            }
        }

        Context -Name 'Env does not exist, create the env'{
            #Mocking the invoke restmethod of from the else block which would return the object it created.
            Mock Invoke-RestMethod -Verifiable -MockWith {
        
                return [PSCustomObject]@{
                    Id = "Environments-99"
                    Name = "Summit.Rocks"
                    Description = "TestPost"
                }
    
            }

            It 'Should Create Summit.Rocks' {
                $CreateEnv = New-OctoEnv -OctoEnvName "Summit.Rocks"
                $CreateEnv.Name | Should -Be 'Summit.Rocks'
            }
        }
    }
}