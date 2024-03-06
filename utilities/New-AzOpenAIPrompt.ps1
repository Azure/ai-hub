function New-AzOpenAIPrompt {
    <#
        Quick function to validate 1) access to Azure Open AI instance (GTP4), and 2) ability to generate a prompt.
        Note: for this to work, the caller ID must have appropriate permissions to the Azure Open AI instance via data plane RBAC.
        
        .Synopsis
        Prompt Azure Open AI using PowerShell function
        .Example
        New-AzOpenAIPrompt -Endpoint "foobar.openai.azure.com" -DeploymentName "gpt4" -Prompt "Why does it rain so much in Bergen, Norway?"
    #>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string] $Endpoint,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $DeploymentName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Prompt
    )

    # Get Token
    $TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
    $MyToken = $TokenRequest.token

$Body = @"
{
    "messages": [
        {
            "role": "system",
            "content": "You are a helpful assistant."
        },
        {
            "role": "user",
            "content": "$($Prompt)"
        }
    ]
}
"@
    # AI Request
    $AzureOAIRequest = @{
        Uri = "https://$($Endpoint)/openai/deployments/$($DeploymentName)/chat/completions?api-version=2023-08-01-preview"
        Headers = @{
            Authorization = "Bearer $($MyToken)"
            'Content-Type' = 'application/json'
            }
        Method = 'POST'
        Body = $Body
        UseBasicParsing = $true
        }
    $Response = Invoke-WebRequest @AzureOAIRequest
    [Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()
}