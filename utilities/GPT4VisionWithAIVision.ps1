# Validation of GPT4-vision and AI Vision indexer

# Azure Open AI configuration

$AzureOpenAIEndpoint = ""
$VisionDeploymentName = ""

# Storage Configuration

$StorageAccountEndpoint = "example.blob.core.windows.net"
$StorageContainer = "videos"
$SasToken = "<provide SAS token here>"
$VideoFile = "myvideo.MOV"

# Azure Vision Configuration

$AzureVisionEndpoint = "example.cognitiveservices.azure.com"
$AzureVisionIndexName = "MyIndex"
$IngestionJob = "MyIngestionJob"
$AzureVisionApiKey = "<provide API key here>"

# Get Token and get started (assuming you have the right RBAC permissions)

$TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
$MyToken = $TokenRequest.token

# Set Indexer Body 

$ExampleIndexBody = @"
{
  "metadataSchema": {
    "fields": [
      {
        "name": "cameraId",
        "searchable": false,
        "filterable": true,
        "type": "string"
      },
      {
        "name": "timestamp",
        "searchable": false,
        "filterable": true,
        "type": "datetime"
      },
      {
        "name": "description",
        "searchable": true,
        "filterable": true,
        "type": "string"
      }
    ]
  },
  "features": [
        {
            "name": "vision",
            "modelVersion": "2023-05-31",
            "domain": "surveillance"
        }
    ]
}
"@  

# PUT AI Vision indexer request

$AzureVisionRequest = @{
    Uri = "https://$($AzureVisionEndpoint)/computervision/retrieval/indexes/$($AzureVisionIndexName)?api-version=2023-05-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        }
    Body = $ExampleIndexBody
    Method = 'PUT'
    }

$Response = Invoke-WebRequest @AzureVisionRequest
[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()

# GET the AI Vision Index

$GetAzureVisionIndexRequest = @{
    Uri = "https://$($AzureVisionEndpoint)/computervision/retrieval/indexes/$($AzureVisionIndexName)?api-version=2023-05-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        }
    Method = 'GET'
    }

$Response = Invoke-WebRequest @GetAzureVisionIndexRequest
[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()

# Add videos to the indexer

$Videos = @"
{
  "videos": [
    {
      "mode": "add",
      "documentId": "$($IngestionJob)",
      "documentUrl": "https://$($StorageAccountEndpoint)/$($StorageContainer)/$($VideoFile)?$($SasToken)",
      "metadata": {}
    }
  ],
  "generateInsightIntervals": false,
  "moderation": false,
  "filterDefectedFrames": false,
  "includeSpeechTranscript": true
}
"@

# PUT AI Vision ingestion job

$AzureVisionIngestionRequest = @{
    Uri = "https://$($AzureVisionEndpoint)/computervision/retrieval/indexes/$($AzureVisionIndexName)/ingestions/$($IngestionJob)?api-version=2023-05-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        }
    Body = $Videos
    Method = 'PUT'
    }
$Response = Invoke-WebRequest @AzureVisionIngestionRequest
[Newtonsoft.Json.Linq.JObject]::Parse($Response.Content).ToString()

# GET AI ingestion job

$GetAzureVisionIngestionRequest = @{
    Uri = "https://$($AzureVisionEndpoint)/computervision/retrieval/indexes/$($AzureVisionIndexName)/ingestions/$($IngestionJob)?api-version=2023-05-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        }
    Method = 'GET'
    }
$GetResponse = Invoke-WebRequest @GetAzureVisionIngestionRequest
[Newtonsoft.Json.Linq.JObject]::Parse($GetResponse.Content).ToString()

# Wait for the ingestion job to complete
$State = $GetResponse | ConvertFrom-Json
while ($State.state -match "Running") {
    Start-Sleep -Seconds 10
    $GetResponse = Invoke-WebRequest @GetAzureVisionIngestionRequest
    $State = $GetResponse | ConvertFrom-Json
    [Newtonsoft.Json.Linq.JObject]::Parse($GetResponse.Content).ToString()
}

# AI Ingestion Request

$VisionBody = @"
{
    "enhancements": {
            "video": {
              "enabled": true
            }
    },
    "dataSources": [
    {
        "type": "AzureComputerVisionVideoIndex",
        "parameters": {
            "endpoint": "https://$($AzureVisionEndpoint)",
            "computerVisionApiKey": "$($AzureVisionApiKey)",
            "indexName": "$($AzureVisionIndexName)",
            "videoUrls": ["https://$($StorageAccountEndpoint)/$($StorageContainer)/$($VideoFile)?$($SasToken)"],
            "roleInformation": "Summarize the important event with associated timestamps"
            }
        }
    ],
    "messages": [ 
        {
            "role": "system",
            "content": [
                {
                    "type": "text",
                    "text": "Summarize the important event with associated timestamps."
                }
            ]
        },
        {
            "role": "user",
            "content": [
                    {
                        "type": "text",
                        "text": "Provide a summary of what is happening in this movie, and provide the subtitles with timestamps"
                    },
                    {
                        "type": "acv_document_id",
                        "acv_document_id": "$($IngestionJob)"
                    }
            ]
        }
    ],
    "temperature": 0.7,
    "top_p": 0.95,
    "max_tokens": 800,
    "stream": false
}
"@

# POST Use Azure OpenAI with Vision

$AzureOpenAIRequest = @{
    Uri = "https://$($AzureOpenAIEndpoint)/openai/deployments/$($VisionDeploymentName)/extensions/chat/completions?api-version=2023-12-01-preview"
    Headers = @{
        Authorization = "Bearer $($MyToken)"
        'Content-Type' = 'application/json'
        }
    Body = $VisionBody
    Method = 'POST'
    }

$AOAIResponse = Invoke-WebRequest @AzureOpenAIRequest
[Newtonsoft.Json.Linq.JObject]::Parse($AOAIResponse.Content).ToString()