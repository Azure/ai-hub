# Use Cases enabled by Enterprise Azure OpenAI Hub

This article provides instructions for how to leverage and validate the initial use case you selected for the Enterprise Azure OpenAI Hub. The use case you selected will determine the deployment and validation steps you need to follow.

## Table of Contents

- [Production Deployment](#production-deployment)
    - ['On Your Data'](#azure-native-rag-on-your-own-data)
        - [PowerShell script for RAG enablement](#powershell-script-for-rag-enablement)
        - [Ingestion job using Azure Open AI, AI Search, and Storage Account](#ingestion-job-using-azure-open-ai-ai-search-and-storage-account)
        - [Content generation using Azure Open AI API endpoint](#content-generation-using-azure-open-ai-api-endpoint)
    - [Image and Video recognition](#image-and-video-recognition)
        - [PowerShell script for image and video recognition](#powershell-script-for-image-and-video-recognition)
        - [Image recognition using Azure Open AI API endpoint](#image-recognition-using-azure-open-ai-api-endpoint)
        - [Video recognition using Azure Open AI API endpoint](#video-recognition-using-azure-open-ai-api-endpoint)
- [Proof of Concept Deployment](#proof-of-concept-deployment)
    - ['On Your Data' with sample Web Application](#on-your-data-with-sample-web-application)
        - [Post deployment configuration for Web Application](#post-deployment-configuration-for-web-application)
    - [Multi region deployment with APIM](#multi-region-deployment-with-apim)
        - [Post deployment validation](#post-deployment-configuration-for-multi-region-deployment)

---

## 'On Your Data'

If you are interested in getting started with the initial Gen AI use case (e.g., Azure native RAG architecture and setup) to accelerate the adoption of Generative AI in your organization, the following instructions and script examples can be used to:

1. Upload files, such as text, images, and videos, to the storage account that you have created as part of the deployment, subject to the configuration you have selected (e.g., the setup highly recommends using Azure RBAC, disabling SAS tokens, and using customer-managed keys for encryption at rest, but if you have selected anything differently, you need to cater for that while getting the data into your storage account).

2. Use the Azure Open AI ingestion API to create one or more indexes in Azure AI Search, to start indexing the data that you have uploaded to the storage account, and make it available for the Azure Open AI instance to enable typical RAG use cases.

3. Use the Azure Open AI API to interact with the Azure Open AI instance, and start generating content based on the data that you have uploaded to the storage account, and indexed in Azure AI Search.

### PowerShell script for RAG enablement

The following PowerShell scripts can be used to 1) start an ingestion job on Azure Open AI to ingest the data from the storage account into Azure AI Search, and 2) access the Azure Open AI API to start generating content based on the data that you have ingested.

#### Ingestion job using Azure Open AI, AI Search, and Storage Account

Modify this script to provide the necessary values for the Azure Open AI endpoint, the embedding deployment name, the ingestion job name, the storage account endpoint, the storage container name, the storage resource ID, and the Azure AI Search endpoint.

```powershell

# Ingestion job using Azure Open AI, AI Search, and Storage Account. The following snippet assumes Managed Identity is properly configured and has the necessary permissions to access the resources, and that the user has Open AI contributor role on the Azure Open AI resource.

# Azure Open AI configuration

$AzureOpenAIEndpoint = ""
$EmbeddingDeploymentName = ""
$IngestionJobName = ""

# Storage Configuration

$StorageAccountEndpoint = ""
$StorageContainerName = ""
$StorageResourceId = ""

# Azure AI search configuraton

$AzureAiSearchEndpoint = ""

# Get Token

$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Set Body (body must be present but empty for the request)
$Body = @'  
{  
}  
'@  

# AI Ingestion Request
$AzureOAIRequest = @{
    Uri = "https://$($AzureOpenAIEndpoint)/openai/extensions/on-your-data/ingestion-jobs/$($IngestionJobName)?api-version=2023-10-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        'storageEndpoint' = "https://$($StorageAccountEndpoint)"
        'storageConnectionString' = "ResourceId=$($StorageResourceId)"
        'storageContainer' = $StorageContainerName
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

```

#### Content generation using Azure Open AI API endpoint

Modify this script to provide the necessary values for the Azure Open AI endpoint, the embedding deployment name, and the model name.

```powershell

#T he following snippet assumes Managed Identity is properly configured and has the necessary permissions to access the resources, and that the user has Open AI reader role on the Azure Open AI resource.

# Azure Open AI configuration

$AzureOpenAIEndpoint = ""
$DeploymentName = ""
$EmbeddingDeploymentName = ""
$Prompt = ""

# Azure AI search configuraton

$AzureAiSearchEndpoint = ""
$IndexName = "" 

# Get Token
$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Form the request body towards the Azure Open AI API endpoint, with AzureCognitiveSearch added as dataSource for RAG
$Body = @"
{
"dataSources": [
    {
        "type": "AzureCognitiveSearch",
        "parameters": {
            "endpoint": "https://$($AzureAiSearchEndpoint)",
            "indexName": "$($IndexName)",
            "embeddingDeploymentName": "$($EmbeddingDeploymentName)"
        }
    }
],
"messages": [
    {
        "role": "system",
        "content": "You are an AI assistant that helps people find information."
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
    Uri = "https://$($AzureOpenAIEndpoint)/openai/deployments/$($DeploymentName)/extensions/chat/completions?api-version=2023-10-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        }
    Method = 'POST'
    Body = $Body
    #UseBasicParsing = $true
    }
$Response = Invoke-WebRequest @AzureOAIRequest
[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()

```