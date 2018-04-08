#. .\src\functions\private\Get-OctoEnvNames.ps1
function Remove-OctoEnv
{
    Param (
        # Parameter help description
        [string]$OctoEnvName

    )

    $apikey = "API-FKFYCH1ZKB37JA7H5QNLKDMDNDC"
    

    $Envs = Get-OctoEnvNames
    #$EnvNames = $Envs.Name

    Foreach ($Env in $Envs)
    {     
        $EnvName = $Env.Name
        $EnvID = $Env.Id   
        if ($EnvName -eq $OctoEnvName)
        { 
            $json = "{ 
                    ""Id"": ""$EnvID""
                    ""Name"": ""$OctoEnvName"", 
                    ""Description"": ""TestPost"",
                    ""SortOrder"": 0,
                    ""UseGuidedFailure"": true
                }" 
                
            Invoke-RestMethod -Uri "http://localhost/api/environments/$EnvID" -Method Delete -Headers @{ "x-Octopus-ApiKey" = $apikey} -Body $json -ContentType 'application/json'      
        }
        else 
        {
            Write-Output "Octopus environment $OctoEnvName doesn't exist"
        }
    }

        
    

}