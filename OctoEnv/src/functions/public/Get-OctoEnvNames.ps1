function Get-OctoEnvNames
{
    $apikey = "API-FKFYCH1ZKB37JA7H5QNLKDMDNDC"

    $results = Invoke-RestMethod -Uri "http://localhost/api/environments" -Method Get -Headers @{ "x-Octopus-ApiKey" = $apikey} -ContentType 'application/json'

    $results.items
}
