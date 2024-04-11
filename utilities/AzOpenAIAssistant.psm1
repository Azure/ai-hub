# Requires -Module Az.Accounts

function Get-AzOpenAIToken {
    $TokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com"
    return $TokenRequest.Token
}

function Invoke-AzOpenAIUploadFile {
    param (
        [string]$FilePath,
        [string]$Endpoint,
        [string]$Purpose = "assistants"
    )

    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }

    $uploadUri = "$Endpoint/openai/files?api-version=2024-03-01-preview"
    $fileItem = Get-Item -Path $FilePath

    $bodyFileUpload = @{
        purpose = $Purpose
        file    = $fileItem
    }

    Invoke-RestMethod -uri $uploadUri -Method Post -Headers $authHeader -ContentType "multipart/form-data" -Form $bodyFileUpload
}

function New-AzOpenAIAssistant {
    param (
        [string]$MetaPromptFile,
        [string]$Model,
        [string[]]$FileIds = @(),
        [string]$Endpoint,
        [string]$AssistantName = ""
    )

    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }
    
    $metaPrompt = (Get-Content -Path $MetaPromptFile) -join "`n"

    if (-not $AssistantName) {
        $AssistantName = (Get-Date -Format "dd-HH-mm-ss") + "-assistant"
    }

    $toolsArray = @(@{ type = "retrieval" }, @{ type = "code_interpreter" })
    
    # Create body for the API request
    $bodyCreateAssistant = @{
        instructions = $metaPrompt
        name         = $AssistantName
        tools        = $toolsArray
        model        = $Model
    }

    # Add file_ids to the body only if $FileIds is not empty
    if ($FileIds) {
        $bodyCreateAssistant['file_ids'] = $FileIds
    }

    $bodyCreateAssistant = $bodyCreateAssistant | ConvertTo-Json -Depth 100

    $assistantUri = "$Endpoint/openai/assistants?api-version=2024-03-01-preview"

    Invoke-RestMethod -uri $assistantUri -Method Post -Headers $authHeader -ContentType "application/json" -Body $bodyCreateAssistant
}

# Requires -Module Az

function Get-AzOpenAIAssistant {
    param (
        [string]$AssistantId = $null,
        [string]$Endpoint
    )

    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }

    $assistantUri = "$Endpoint/openai/assistants"
    if ($AssistantId) {
        $assistantUri += "/$AssistantId"
    }
    $assistantUri += "?api-version=2024-02-15-preview"
    Invoke-RestMethod -uri $assistantUri -Method Get -Headers $authHeader
}

function New-AzOpenAIAssistantFunction {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [string]$RequiredPropertyName,

        [Parameter(Mandatory = $true)]
        [string]$PropertyDescription,

        [Parameter(Mandatory = $true)]
        [string]$Endpoint,

        [Parameter(Mandatory = $true)]
        [string]$AssistantId,

        [Parameter(Mandatory = $true)]
        [string]$Instructions
    )

    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }

    $requiredProperties = @{
        $RequiredPropertyName = @{
            "type" = "string"
            "description" = $PropertyDescription
        }
    }
    
    # Placeholder for logic to derive model from AssistantId
    $model = Get-AzOpenAIAssistant -AssistantId $AssistantId -Endpoint $Endpoint | Select-Object -ExpandProperty model

    $body = @{
        "instructions" = $Instructions
        "tools" = @(
            @{
                "type" = "function"
                "function" = @{
                    "name" = $Name
                    "description" = $Description
                    "parameters" = @{
                        "type" = "object"
                        "properties" = $requiredProperties
                        "required" = @($RequiredPropertyName)
                    }
                }
            }
        )
        "id" = $AssistantId
        "model" = $model
    } | ConvertTo-Json -Depth 100

    $ApiVersion = "2024-02-15-preview"
    $assistantUri = "$Endpoint/openai/assistants?api-version=$ApiVersion"

    Invoke-RestMethod -Uri $assistantUri -Method Post -Headers $authHeader -ContentType "application/json" -Body $body
}

# Function to create a new thread
function New-AzOpenAIAssistantThread {
    param (
        [string]$Endpoint
    )
    
    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }
    
    
    # Corrected endpoint URL to create a new thread
    $threadUri = "$Endpoint/openai/threads?api-version=2024-03-01-preview"
    
    # Send the API request and return the thread ID
    $response = Invoke-RestMethod -uri $threadUri -Method Post -Headers $authHeader -ContentType "application/json" -Body $bodyJson
    
    return $response.id

}

# Function to retrieve an existing thread

function Get-AzOpenAIAssistantThread {
    param (
        [string]$Endpoint,
        [string]$ThreadID = ""
    )
    
    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }
    
    
    # Corrected endpoint URL to create a new thread
    $threadUri = "$Endpoint/openai/threads/$ThreadID?api-version=2024-03-01-preview"
    
    # Send the API request and return the thread ID
    $response = Invoke-RestMethod -uri $threadUri -Method Get -Headers $authHeader -ContentType "application/json" -Body $bodyJson
    
    return $response

}

# Function to post a message to a thread
function Post-AzOpenAIAssistantMessage {
    param (
        [string]$ThreadID,
        [string]$Message,
        [string]$Endpoint
    )
    
    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }
    
    $bodyNewMessage = @(
        @{
            role = "user"
            content = $message
        }
    )
    
    $bodyJson = $bodyNewMessage | ConvertTo-Json -Depth 100

    # Corrected endpoint URL to post message to a thread
    $messageUri = "$Endpoint/openai/threads/$ThreadID/messages?api-version=2024-03-01-preview"
    
    # Send the API request to post the message and return the response
    $response = Invoke-RestMethod -uri $messageUri -Method Post -Headers $authHeader -ContentType "application/json" -Body $bodyJson
    
    return $response
}

function Start-AzOpenAIAssistantThreadRun {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssistantId,

        [Parameter(Mandatory = $true)]
        [string]$ThreadID,

        [Parameter(Mandatory = $true)]
        [string]$Endpoint,

        [switch]$Async
    )
    
    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }
    
    # Create the body for the run request, including the AssistantId
    $bodyStartRun = @{
        assistant_id = $AssistantId
    }
    
    $bodyJson = $bodyStartRun | ConvertTo-Json -Depth 100
    
    # Endpoint URL to start a run on a thread
    $threadRunUri = "$Endpoint/openai/threads/$ThreadID/runs?api-version=2024-03-01-preview"
    
    # Send the API request to start a run on the thread
    $runResponse = Invoke-RestMethod -uri $threadRunUri -Method Post -Headers $authHeader -ContentType "application/json" -Body $bodyJson

    if (-not $Async) {
        # Check status and wait for completion if not in Async mode
        $i = 0
        do {
            $i++
            Write-Host "Checking status $i"
            $statusUri = "$Endpoint/openai/threads/$ThreadID/runs/$($runResponse.id)?api-version=2024-03-01-preview"
            $runResult = Invoke-RestMethod -uri $statusUri -Headers $authHeader
            $runResult | Select-Object id, assistant_id, thread_id, status, last_error
            Start-Sleep -Seconds 10
        } while ($runResult.status -ne "completed" -and $i -lt 100)

        if ($runResult.status -eq "completed") {
            # Get results if the run has completed
            $messagesUri = "$Endpoint/openai/threads/$ThreadID/messages?api-version=2024-03-01-preview"
            $resultMessage = Invoke-RestMethod -uri $messagesUri -Headers $authHeader
            $resultMessage.data.ForEach({ $_.content.text | Select-Object -ExpandProperty value })
        } else {
            Write-Host "Run did not complete within the specified time."
        }
    } else {
        Write-Host "Run started in Async mode. Use Get-AzOpenAIAssistantThreadStatus to check the run status later."
    }
    
    # Return the run ID for later status checks if needed
    return $runResponse.id
}


function Get-AzOpenAIAssistantThreadStatus {
    param (
        [string]$ThreadID,
        [string]$RunID,
        [string]$Endpoint
    )

    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }

    # Make sure the URI is constructed correctly
    $statusUri = "$Endpoint/openai/threads/$ThreadID/runs/$RunID?api-version=2024-02-15-preview"

    # Use try-catch block to handle any errors that occur during the API call
    try {
        $response = Invoke-RestMethod -uri $statusUri -Method Get -Headers $authHeader
        return $response
    }
    catch {
        Write-Error "Failed to get thread status: $_"
        return $null
    }
}

function Get-AzOpenAIAssistantMessages {
    param (
        [string]$ThreadID,
        [string]$Endpoint
    )
    
    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }

    $messagesUri = "$Endpoint/openai/threads/$ThreadID/messages?api-version=2024-02-15-preview"

    Invoke-RestMethod -uri $messagesUri -Headers $authHeader
}
function Start-AzOpenAIAssistantThreadWithMessages {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssistantId,

        [Parameter(Mandatory = $true)]
        [string]$Endpoint,

        [Parameter(Mandatory)]
        [string]$MessageContent,

        [switch]$Async
    )
    
    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }
    
    # Create thread messages
    $messages = @(
        @{
            role    = "user"
            content = $MessageContent
        }
    )

    # Create the body for starting a thread
    $bodyThread = @{
        assistant_id = $AssistantId
        thread       = @{
            messages = $messages
        }
    } | ConvertTo-Json -Depth 100

    # Endpoint URL to start a new thread
    $threadUri = "$Endpoint/openai/threads/runs?api-version=2024-03-01-preview"
    
    # Send the API request to start a new thread
    $threadResponse = Invoke-RestMethod -uri $threadUri -Method Post -Headers $authHeader -ContentType "application/json" -Body $bodyThread
    $ThreadID = $threadResponse.thread_id
    
    if (-not $Async) {
        # Check status and wait for completion if not in Async mode
        $i = 0
        do {
            $i++
            Write-Host "Checking status $i"
            $statusUri = "$Endpoint/openai/threads/$ThreadID/runs/$($threadResponse.id)?api-version=2024-03-01-preview"
            $runResult = Invoke-RestMethod -uri $statusUri -Headers $authHeader
            $runResult | Select-Object id, assistant_id, thread_id, status, last_error
            Start-Sleep -Seconds 10
        } while ($runResult.status -ne "completed" -and $i -lt 100)

        if ($runResult.status -eq "completed") {
            # Get results if the run has completed
            $messagesUri = "$Endpoint/openai/threads/$ThreadID/messages?api-version=2024-03-01-preview"
            $resultMessage = Invoke-RestMethod -uri $messagesUri -Headers $authHeader
            $resultMessage.data.ForEach({ $_.content.text | Select-Object -ExpandProperty value })
        } else {
            Write-Host "Run did not complete within the specified time."
        }
    } else {
        Write-Host "Thread run started in Async mode. Use Get-AzOpenAIAssistantThreadStatus to check the thread status later."
    }
    
    # Return the thread and run ID for later status checks if needed
    return @{
        ThreadID = $ThreadID
        RunID = $threadResponse.id
    }
}

function Remove-AzOpenAIAssistants {
    param (
        [string]$Endpoint
    )

    $authHeader = @{
        Authorization = "Bearer $(Get-AzOpenAIToken)"
    }

    $assistantsUri = "$Endpoint/openai/assistants?api-version=2024-02-15-preview"
    $assistants = Invoke-RestMethod -uri $assistantsUri -Headers $authHeader

    foreach ($assistant in $assistants.data) {
        Write-Host "Deleting $($assistant.id)"
        $deleteUri = "$Endpoint/openai/assistants/$($assistant.id)?api-version=2024-02-15-preview"
        Invoke-RestMethod -uri $deleteUri -Headers $authHeader -Method Delete
    }
}

Export-ModuleMember -Function Get-AzOpenAIToken, Start-AzOpenAIAssistantThreadWithMessages, Get-AzOpenAIAssistantThread, Invoke-AzOpenAIUploadFile, New-AzOpenAIAssistant, Get-AzOpenAIAssistant, New-AzOpenAIAssistantFunction, New-AzOpenAIAssistantThread, Post-AzOpenAIAssistantMessage, Start-AzOpenAIAssistantThreadRun, Get-AzOpenAIAssistantThreadStatus, Get-AzOpenAIAssistantMessages, Remove-AzOpenAIAssistants