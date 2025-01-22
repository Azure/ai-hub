# Ingestion job using Azure Open AI, AI Search, and Storage Account. The following snippet assumes Managed Identity is properly configured and has the necessary permissions to access the resources.

# Azure Open AI configuration

$AzureOpenAIEndpoint = "knop-swedencentral-azopenai.openai.azure.com"
$EmbeddingDeploymentName = "hub-embedding-text-embedding-ada-002"

# Azure AI search configuraton

$AzureAiSearchEndpoint = "knop-swedencentral-azaisearch.search.windows.net"

# Azure Open AI Ingestion job configuration which will create the index and subsequent blobs in the storage account with the same name
$IngestionJob = "ingestion2"

# Storage Configuration

$StorageAccountEndpoint = "knopswedencentralhn4u4k.blob.core.windows.net"
$StorageContainer = "docs"
$StorageConnection = "/subscriptions/3abc6ba0-af7f-4bec-a87b-27fecc2be361/resourceGroups/knop-rg-swedencentral/providers/Microsoft.Storage/storageAccounts/knopswedencentralhn4u4k/blobServices/default"

# Get Token

$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Set Body
$requestBody = @{
    kind = "SystemCompute"
    overrides = @{
        useFr = $false
        useVision = $false
    }
    searchServiceConnection = @{
        kind = "EndpointWithManagedIdentity"
        endpoint = "https://$($AzureAiSearchEndpoint)"
    }
    datasource = @{
        kind = "Storage"
        storageAccountConnection = @{
            kind = "EndpointWithManagedIdentity"
            resourceId = "ResourceId=$($StorageConnection)"
            endpoint = "https://$($StorageAccountEndpoint)"
        }
        containerName = $StorageContainer
        embeddingsSettings = @(
            @{
                embeddingResourceConnection = @{
                    kind = "RelativeConnection"
                }
                deploymentName = $EmbeddingDeploymentName
            }
        )
        chunkingSettings = @{
            maxChunkSizeInTokens = 1024
        }
    }
    dataRefreshIntervalInHours = 3
}

# AI Ingestion Request
$AzureOAIRequest = @{
    Uri = "https://$($AzureOpenAIEndpoint)/openai/ingestion/jobs/$($IngestionJob)?api-version=2024-05-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        }
    Body = $requestBody | ConvertTo-Json -Depth 100
    Method = 'PUT'
    }
    
$Response = Invoke-WebRequest @AzureOAIRequest
[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()