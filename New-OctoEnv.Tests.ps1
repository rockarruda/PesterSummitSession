. .\Get-OctoEnvNames.ps1
. .\New-OctoEnv.ps1

Describe -Name 'TestOctoEnv' {

    Context -Name 'EnvExits' {

        Mock Get-OctoEnvNames -Verifiable -MockWith {
        
            return [PSCustomObject]@{
                Id = "Environments-99"
                Name = "Hey.Doug"
                Description = "TestPost"
            }
    
        }
         
        It 'Should return environment exists' {
            $EnvName = New-OctoEnv -OctoEnvName "Hey.Doug"
            $EnvName | Should -Be "Hey.Doug already exists"
        }
    }

    Context -Name 'Env does not exist, create it'{

        Mock Invoke-RestMethod -Verifiable -MockWith {
        
            return [PSCustomObject]@{
                Id = "Environments-99"
                Name = "Hey.Doug"
                Description = "TestPost"
            }
    
        }

        It 'Should Create Hey.Doug' {
            $CreateEnv = New-OctoEnv -OctoEnvName "Hey.Doug"
            $CreateEnv.Name | Should -Be 'Hey.Doug'
        }
    }
}