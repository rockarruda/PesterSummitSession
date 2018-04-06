. .\Get-OctoEnvNames.ps1
. .\New-OctoEnv.ps1

Describe -Name 'TestOctoEnv' {

    Mock Invoke-Restmethod {
        result @{
            Name = "Hey.Doug"
        }

    }

    Context -Name 'EnvExits' {
        
    }
}