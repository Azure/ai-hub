# Analyze document with Azure Document Intelligence

# Azure Document Intelligence configuration
$azureDocIntelEndpoint = "example.cognitiveservices.azure.com"
$modelId = "prebuilt-layout"

# Get Token
$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Set Body 
$Body = @'  
{
    "urlSource": "https://example.blob.core.windows.net/docsin/layout.png?<SAS token goes here>"    
}  
'@  

# AI Doc Intel request
$AzureOAIRequest = @{
    Uri = "https://$($azureDocIntelEndpoint)/documentintelligence/documentModels/$($modelId):analyze?_overload=analyzeDocument&api-version=2023-10-31-preview&outputContentFormat=markdown"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        }
    Body = $Body
    Method = 'POST'
    }
    
$Response = Invoke-WebRequest @AzureOAIRequest
#[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()
$Response.RawContent

# Get Analyze Document Result

    $GetStatusRequest = @{
        Uri = "https://$($azureDocIntelEndpoint)/documentintelligence/documentModels/$($modelId)/analyzeResults/8e7b7fa8-89cf-4caa-b8ca-b86840648c58?api-version=2023-10-31-preview"
        Headers = @{
            Authorization = "Bearer $($MyToken)"
        }
    Method = 'GET'
    }
    $GetResponse = Invoke-WebRequest @GetStatusRequest
    [Newtonsoft.Json.Linq.JObject]::Parse($GetResponse.Content).ToString()

    # Wait for the ingestion job to complete
$State = $GetResponse | ConvertFrom-Json
while ($State.status -match "notRunning" -or $state.status -match "running") {
    Start-Sleep -Seconds 10
    $GetResponse = Invoke-WebRequest @GetStatusRequest
    $State = $GetResponse | ConvertFrom-Json
    [Newtonsoft.Json.Linq.JObject]::Parse($GetResponse.Content).ToString()
}