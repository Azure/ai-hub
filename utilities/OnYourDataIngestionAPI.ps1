# Ingestion job using Azure Open AI, AI Search, and Storage Account. The following snippet assumes Managed Identity is properly configured and has the necessary permissions to access the resources.

# Azure Open AI configuration

$AzureOpenAIEndpoint = "<resource-name>.openai.azure.com"
$EmbeddingDeploymentName = "embedding"

# Azure AI search configuraton

$AzureAiSearchEndpoint = "<resource-name>.search.windows.net"

# Azure Open AI Ingestion job configuration which will create the index and subsequent blobs in the storage account with the same name
$IngestionJob = "Ingestion1"

# Storage Configuration

$StorageAccountEndpoint = "<resourec-name>blob.core.windows.net"
$StorageContainer = "docs"
$StorageConnection = "<full resourceId of the storage account>"

# Get Token

$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Set Body
$Body = @'  
{
    "completionAction": "keepAllAssets",
    "dataRefreshIntervalInMinutes": 60,
    "chunkSize": 1024
}  
'@  

# AI Ingestion Request
$AzureOAIRequest = @{
    Uri = "https://$($AzureOpenAIEndpoint)/openai/extensions/on-your-data/ingestion-jobs/$($IngestionJob)?api-version=2023-10-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        'storageEndpoint' = "https://$($StorageAccountEndpoint)"
        'storageConnectionString' = "ResourceId=$($StorageConnection)"
        'storageContainer' = $StorageContainer
        'searchServiceEndpoint' = "https://$($AzureAiSearchEndpoint)"
        'embeddingDeploymentName' = $EmbeddingDeploymentName
        }
    Body = $Body
    Method = 'PUT'
    }
    
$Response = Invoke-WebRequest @AzureOAIRequest
[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()

# Get Status on the ingestion job

    $GetStatusRequest = @{
        Uri = "https://$($AzureOpenAIEndpoint)/openai/extensions/on-your-data/ingestion-jobs/$($IngestionJob)?api-version=2023-10-01-preview"
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
}
