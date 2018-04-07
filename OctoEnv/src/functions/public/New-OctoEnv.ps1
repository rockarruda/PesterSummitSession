. .\src\functions\private\Get-OctoEnvNames.ps1
function New-OctoEnv
{
    Param (
        # Parameter help description
        [string]$OctoEnvName

    )

    $apikey = "API-FKFYCH1ZKB37JA7H5QNLKDMDNDC"
    $json = "{ 
    ""Name"": ""$OctoEnvName"", 
    ""Description"": ""TestPost"",
    ""SortOrder"": 0,
    ""UseGuidedFailure"": true
    }"

        $EnvNames = Get-OctoEnvNames

            if($EnvNames.Name -contains $OctoEnvName)
            {
                
                Write-Output "$OctoEnvName already exists"    
            }
            else 
            {
                Write-Output "Creating Octopus environment : $OctoEnvName"
                Invoke-RestMethod -Uri "http://localhost/api/environments" -Method Post -Headers @{ "x-Octopus-ApiKey" = $apikey} -Body $json -ContentType 'application/json'    
            }

        
    

}