

Import-Module "C:\github\PesterSummitSession\OctoEnv\src\OctoEnv.psd1" -Force

InModuleScope OctoEnv {

    Describe -Name 'TestOctoEnv' -Tag 'Integration' {

        <#Context -Name 'EnvExits' {

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
                $EnvName = New-OctoEnv -OctoEnvName "Hey.Doug"
                $EnvName | Should -Be "Summit.Rocks already exists"
            }
        }#>

        Context -Name 'Env does not exist, create it'{

            <#Mock Invoke-RestMethod -Verifiable -MockWith {
        
                return [PSCustomObject]@{
                    Id = "Environments-99"
                    Name = "Summit.Rocks"
                    Description = "TestPost"
                }
    
            }#>

            It 'Should Create Summit.Rocks' {
                Remove-OctoEnv -OctoEnvName "Summit.Rocks"
                $CreateEnv = New-OctoEnv -OctoEnvName "Summit.Rocks"
                $CreateEnv.Name | Should -Be 'Summit.Rocks'
            }
        }
    }
}