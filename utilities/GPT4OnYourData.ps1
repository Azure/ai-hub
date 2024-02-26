
# Azure Open AI configuration

$AzureOpenAIEndpoint = "<resource-name>.openai.azure.com"
$EmbeddingDeploymentName = "embedding"

# Azure AI search configuraton

$AzureAiSearchEndpoint = "<resource-name>.search.windows.net"

$DeploymentName = "GPT4"
$Prompt = "Find information about my health insurance."

# Azure AI search configuraton

$IndexName = "myindex"

# Get Token
$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Form the request body towards the Azure Open AI API endpoint, with AzureCognitiveSearch added as dataSource for RAG
$Body = @"
{
    "dataSources": [
        {
            "type": "AzureCognitiveSearch",
            "queryType": "vectorSimpleHybrid",
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

    $PSResponse = $Response.Content | ConvertFrom-Json
