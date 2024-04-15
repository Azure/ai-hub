
resource "azurerm_data_factory" "data_factory" {
  name                = var.adf_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
identity {
    type = "SystemAssigned"
  }
} 

resource "azurerm_data_factory_pipeline" "singleAnalyzeDocument" {
  name            = "singleAnalyzeDocument"
  data_factory_id = azurerm_data_factory.data_factory.id
  parameters = {
        "fileName" = "layout.png",
        "gpt4_deployment_name" = "gpt-4",
        "openai_api_base" = "https://esp1-swedencentral-azopenai.openai.azure.com/" 
        "cosmosaccount" = "https://esp1-swedencentral-cosmosdb.documents.azure.com:443/",
        "cosmoscontainer"= "docs",
        "cosmosdb" = "responses",
        "storageaccounturl" = "https://useme.blob.core.windows.net/",
        "storageAccountContainer" = "docsin",
        "temperature" = "1",
        "top_p" = "1",
        "searchServiceEndpoint" = "https://esp1-swedencentral-azaisearch.search.windows.net",
        "indexName" = "esp1test",
        "embeddingDeploymentName"  = "embedding",
        "sys_message" = "You are an AI assistant that helps people find information.",
        "user_prompt" = "Summarize the data for me.",
        "storageaccountcontainer" = "docsin",
        "storageAccountResourceId" = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/esp1-rg-swedencentral/providers/Microsoft.Storage/storageAccounts/useme",
        "documentIntelligenceAPI" = "https://esp1-westeurope-docintel.cognitiveservices.azure.com/",
        "modelId" = "prebuilt-layout",
        "aiSearchIndexName" = "esp1test",
        "openAIAPI" = "https://esp1-swedencentral-azopenai.openai.azure.com/"  

    }

  activities_json = <<JSON
[
{
    "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "rgName": {
            "type": "string",
            "metadata": {
                "description": "Select the naming convertion for the resource group that will be created"
            }
        },
        "location": {
            "type": "string",
            "metadata": {
                "description": "Provide the Azure region for the storage accont"
            }
        },
        "prefix": {
            "type": "string",
            "metadata": {
                "description": "Provide a prefix for the resources that will be created as part of the storage account"
            }
        },
        "dfSubnetId": {
            "type": "string",
            "defaultValue": ""
        },
        "dfDisableNetworkAccess": {
            "type": "string",
            "defaultValue": "No",
            "allowedValues": [
                "Yes",
                "No"
            ]
        },
        "dfNwLocation": {
            "type": "string",
            "defaultValue": "[parameters('location')]"
        },
        "dfSystemIdentity": {
            "type": "string",
            "defaultValue": "No",
            "allowedValues": [
                "Yes",
                "No"
            ]
        },
        "dfMonCreation": {
            "type": "string",
            "defaultValue": "No",
            "allowedValues": [
                "Yes",
                "No"
            ]
        },
        "azMonWorkspaceName": {
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "Provide the resource name of the Azure Monitor workspace where the Azure Open AI instance that will be connected"
            }
        },
        "storageAccountBlobEndpoint": {
            "type": "string",
            "defaultValue": "https://tfswitzerlandnorthnzglm.blob.core.windows.net/"
        },
        "cosmosDbNoSqlEndpoint": {
            "type": "string",
            "defaultValue": "https://tf-switzerlandnorth-cosmosdb.documents.azure.com:443/"
        },
        "cosmosDbNoSqlDatabase": {
            "type": "string",
            "defaultValue": "responses"
        },
        "cosmosDbNoSqlContainer": {
            "type": "string",
            "defaultValue": "docs"
        },
        "onYourData_properties_typeProperties_url": {
            "type": "string",
            "defaultValue": "@{linkedService().documentIntelligenceAPI}documentintelligence/documentModels/@{linkedService().modelId}/analyzeResults/@{linkedService().resultID}?api-version=2023-10-31-preview"
        },
        "GPT4Deployment_properties_typeProperties_url": {
            "type": "string",
            "defaultValue": "@{linkedService().open_ai_base}"
        },
        "triggerDocBlob_properties_singleAnalyzeDocument_parameters_fileName": {
            "type": "string",
            "defaultValue": "@triggerBody().fileName"
        },
        "azureOpenAiEndpoint": {
            "type": "string",
            "defaultValue": "https://tf-switzerlandnorth-azopenai.openai.azure.com/"
        },
        "systemMessage": {
            "type": "string",
            "defaultValue": "You are an AI assistant that helps people find information."
        },
        "userPrompt": {
            "type": "string",
            "defaultValue": "Summarize the data for me."
        },
        "storageAccountContainer": {
            "type": "string",
            "defaultValue": "docs"
        },
        "temperature": {
            "type": "string",
            "defaultValue": "1"
        },
        "topP": {
            "type": "string",
            "defaultValue": "1"
        },
        "documentIntelligenceEndpoint": {
            "type": "string",
            "defaultValue": "https://tf-westeurope-azdocintel.cognitiveservices.azure.com/"
        },
        "documentIntelligenceModelId": {
            "type": "string",
            "defaultValue": "prebuilt-layout"
        },
        "aiSearchServiceEndpoint": {
            "type": "string",
            "defaultValue": "https://tf-switzerlandnorth-azaisearch.search.windows.net/"
        },
        "embeddingsDeploymentName": {
            "type": "string",
            "defaultValue": "hub-embedding-text-embedding-ada-002"
        },
        "gpt4DeploymentName": {
            "type": "string",
            "defaultValue": "hub-gpt4-gpt-4"
        },
        "storageAccountResourceId": {
            "type": "string",
            "defaultValue": "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/tf-rg-switzerlandnorth/providers/Microsoft.Storage/storageAccounts/tfswitzerlandnorthnzglm"
        },
        "indexName": {
            "type": "string",
            "defaultValue": "eaoaiindex"
        },
        "cosmosDbNoSqlResourceId": {
            "type": "string",
            "defaultValue": "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/tf-rg-switzerlandnorth/providers/Microsoft.DocumentDB/databaseAccounts/tf-switzerlandnorth-cosmosdb"
        },
        "aiSearchResourceId": {
            "type": "string",
            "defaultValue": "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/tf-rg-switzerlandnorth/providers/Microsoft.Search/searchServices/tf-switzerlandnorth-azaisearch"
        },
        "azureOpenAiResourceId": {
            "type": "string",
            "defaultValue": "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/tf-rg-switzerlandnorth/providers/Microsoft.CognitiveServices/accounts/tf-switzerlandnorth-azopenai"
        },
        "documentIntelligenceResourceId": {
            "type": "string",
            "defaultValue": "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/tf-rg-switzerlandnorth/providers/Microsoft.CognitiveServices/accounts/tf-westeurope-azdocintel"
        }
    },
    "variables": {
        "name-compliant-df": "[concat(parameters('prefix'), '-', parameters('location'), '-azdf')]",
        "name-compliant-df-asg": "[concat(parameters('prefix'), '-', parameters('location'), '-azdf-asg')]",
        "name-compliant-df-pe": "[concat(parameters('prefix'), '-', parameters('location'), '-azdf-pe')]",
        "name-compliant-df-nic": "[concat(variables('name-compliant-df'), '-nic')]",
        "dfIdentity": {
            "type": "SystemAssigned"
        },
        "factoryId": "[concat('Microsoft.DataFactory/factories/', variables('name-compliant-df'))]",
        "msiAuthEndpoint": "https://cognitiveservices.azure.com",
        "managedIntegrationRuntime": {
            "referenceName": "AzureIntegrationRuntime",
            "type": "IntegrationRuntimeReference"
        },
        "azPolicyEnabled": {
            "PolicyValidationEnabled": "true"
        }
    },
    "resources": [
        {
            "type": "Microsoft.Resources/resourceGroups",
            "apiVersion": "2020-06-01",
            "location": "[parameters('location')]",
            "name": "[parameters('rgName')]",
            "properties": {}
        },
        {
            "type": "Microsoft.Resources/deployments",
            "apiVersion": "2022-09-01",
            "name": "dataFactory",
            "resourceGroup": "[parameters('rgName')]",
            "dependsOn": [
                "[concat('Microsoft.Resources/resourceGroups/', parameters('rgName'))]"
            ],
            "properties": {
                "mode": "Incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "resources": [
                        {
                            "type": "Microsoft.DataFactory/factories",
                            "apiVersion": "2018-06-01",
                            "name": "[variables('name-compliant-df')]",
                            "location": "[parameters('location')]",
                            "identity": "[if(equals(parameters('dfSystemIdentity'), 'Yes'), variables('dfIdentity'), json('null'))]",
                            "properties": {
                                "publicNetworkAccess": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), 'Disabled', 'Enabled')]",
                                "globalConfigurations": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), variables('azPolicyEnabled'), json('null'))]"
                            }
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/default')]",
                            "type": "Microsoft.DataFactory/factories/managedVirtualNetworks",
                            "apiVersion": "2018-06-01",
                            "properties": {},
                            "dependsOn": [
                                "[concat('Microsoft.DataFactory/factories/', variables('name-compliant-df'))]"
                            ]
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/default/AzureBlobStorage')]",
                            "type": "Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "privateLinkResourceId": "[parameters('storageAccountResourceId')]",
                                "groupId": "blob"
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/managedVirtualNetworks/default')]"
                            ]
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/default/AzureCosmosDb')]",
                            "type": "Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "privateLinkResourceId": "[parameters('cosmosDbNoSqlResourceId')]",
                                "groupId": "Sql"
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/managedVirtualNetworks/default')]"
                            ]
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/default/AzureAiSearch')]",
                            "type": "Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "privateLinkResourceId": "[parameters('aiSearchResourceId')]",
                                "groupId": "searchService"
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/managedVirtualNetworks/default')]"
                            ]
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/default/AzureOpenAi')]",
                            "type": "Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "privateLinkResourceId": "[parameters('azureOpenAiResourceId')]",
                                "groupId": "account"
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/managedVirtualNetworks/default')]"
                            ]
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/default/DocumentIntelligence')]",
                            "type": "Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "privateLinkResourceId": "[parameters('documentIntelligenceResourceId')]",
                                "groupId": "account"
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/managedVirtualNetworks/default')]"
                            ]
                        },
                        {
                            "condition": "[equals(parameters('dfDisableNetworkAccess'), 'Yes')]",
                            "name": "[concat(variables('name-compliant-df'), '/AzureIntegrationRuntime')]",
                            "type": "Microsoft.DataFactory/factories/integrationRuntimes",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "type": "Managed",
                                "typeProperties": {
                                    "computeProperties": {
                                        "location": "[parameters('location')]",
                                        "dataFlowProperties": {
                                            "computeType": "General",
                                            "coreCount": 8,
                                            "timeToLive": 10,
                                            "cleanup": false,
                                            "customProperties": []
                                        },
                                        "pipelineExternalComputeScaleProperties": {
                                            "timeToLive": 60,
                                            "numberOfPipelineNodes": 1,
                                            "numberOfExternalNodes": 1
                                        }
                                    }
                                },
                                "managedVirtualNetwork": {
                                    "type": "ManagedVirtualNetworkReference",
                                    "referenceName": "default"
                                }
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/managedVirtualNetworks/default')]"
                            ]
                        },
                        {
                            "condition": "[and(equals(parameters('dfDisableNetworkAccess'), 'Yes'), not(empty(parameters('dfSubnetId'))))]",
                            "type": "Microsoft.Network/applicationSecurityGroups",
                            "apiVersion": "2023-04-01",
                            "name": "[variables('name-compliant-df-asg')]",
                            "location": "[parameters('dfNwLocation')]",
                            "dependsOn": [
                                "[concat('Microsoft.DataFactory/factories/', variables('name-compliant-df'))]"
                            ],
                            "properties": {}
                        },
                        {
                            "condition": "[and(equals(parameters('dfDisableNetworkAccess'), 'Yes'), not(empty(parameters('dfSubnetId'))))]",
                            "type": "Microsoft.Network/privateEndpoints",
                            "apiVersion": "2021-05-01",
                            "name": "[variables('name-compliant-df-pe')]",
                            "location": "[parameters('dfNwLocation')]",
                            "dependsOn": [
                                "[concat('Microsoft.DataFactory/factories/', variables('name-compliant-df'))]",
                                "[concat('Microsoft.Network/applicationSecurityGroups/', variables('name-compliant-df-asg'))]"
                            ],
                            "properties": {
                                "customNetworkInterfaceName": "[variables('name-compliant-df-nic')]",
                                "privateLinkServiceConnections": [
                                    {
                                        "name": "[variables('name-compliant-df-pe')]",
                                        "properties": {
                                            "privateLinkServiceId": "[concat('/subscriptions/', subscription().subscriptionId, '/resourceGroups/', parameters('rgName'), '/providers/Microsoft.DataFactory/factories/', variables('name-compliant-df'))]",
                                            "groupIds": [
                                                "dataFactory"
                                            ]
                                        }
                                    }
                                ],
                                "subnet": {
                                    "id": "[parameters('dfSubnetId')]"
                                },
                                "applicationSecurityGroups": [
                                    {
                                        "id": "[concat('/subscriptions/', subscription().subscriptionId, '/resourceGroups/', parameters('rgName'), '/providers/Microsoft.Network/applicationSecurityGroups/', variables('name-compliant-df-asg'))]"
                                    }
                                ]
                            }
                        },
                        {
                            "condition": "[equals(parameters('dfMonCreation'), 'Yes')]",
                            "type": "Microsoft.DataFactory/factories/providers/diagnosticSettings",
                            "apiVersion": "2021-05-01-preview",
                            "name": "[concat(variables('name-compliant-df'), '/', 'Microsoft.Insights/diag')]",
                            "location": "[parameters('location')]",
                            "dependsOn": [
                                "[variables('factoryId')]"
                            ],
                            "properties": {
                                "workspaceId": "[concat(subscription().id, '/resourceGroups/', parameters('rgName'), '/providers/Microsoft.OperationalInsights/workspaces/', parameters('azMonWorkspaceName'))]",
                                "logs": [
                                    {
                                        "categoryGroup": "allLogs",
                                        "enabled": true
                                    }
                                ]
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/AzureOpenAI')]",
                            "type": "Microsoft.DataFactory/factories/datasets",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/linkedServices/GPT4Deployment')]"
                            ],
                            "properties": {
                                "linkedServiceName": {
                                    "referenceName": "GPT4Deployment",
                                    "type": "LinkedServiceReference",
                                    "parameters": {
                                        "open_ai_base": {
                                            "value": "@dataset().openai_api_base",
                                            "type": "Expression"
                                        },
                                        "gpt4deployment": {
                                            "value": "@dataset().gpt4_deployment_name",
                                            "type": "Expression"
                                        }
                                    }
                                },
                                "parameters": {
                                    "openai_api_base": {
                                        "type": "String"
                                    },
                                    "gpt4_deployment_name": {
                                        "type": "string"
                                    },
                                    "relative_url": {
                                        "type": "string"
                                    }
                                },
                                "annotations": [],
                                "type": "RestResource",
                                "typeProperties": {
                                    "relativeUrl": {
                                        "value": "@dataset().relative_url",
                                        "type": "Expression"
                                    }
                                },
                                "schema": []
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'),'/CosmosGPTOutput')]",
                            "type": "Microsoft.DataFactory/factories/datasets",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/linkedServices/CosmosDbNoSql')]"
                            ],
                            "properties": {
                                "linkedServiceName": {
                                    "referenceName": "CosmosDbNoSql",
                                    "type": "LinkedServiceReference"
                                },
                                "parameters": {
                                    "cosmosaccount": {
                                        "type": "string"
                                    },
                                    "cosmosdb": {
                                        "type": "string"
                                    },
                                    "cosmoscontainer": {
                                        "type": "string"
                                    }
                                },
                                "annotations": [],
                                "type": "CosmosDbSqlApiCollection",
                                "schema": {},
                                "typeProperties": {
                                    "collectionName": {
                                        "value": "@dataset().cosmoscontainer",
                                        "type": "Expression"
                                    }
                                }
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/onYourData')]",
                            "type": "Microsoft.DataFactory/factories/datasets",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/linkedServices/onYourData')]"
                            ],
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "linkedServiceName": {
                                    "referenceName": "onYourData",
                                    "type": "LinkedServiceReference",
                                    "parameters": {
                                        "documentIntelligenceAPI": {
                                            "value": "@dataset().documentIntelligenceAPI",
                                            "type": "Expression"
                                        },
                                        "modelId": {
                                            "value": "@dataset().modelId",
                                            "type": "Expression"
                                        },
                                        "resultID": {
                                            "value": "@dataset().resultID",
                                            "type": "Expression"
                                        }
                                    }
                                },
                                "parameters": {
                                    "documentIntelligenceAPI": {
                                        "type": "string"
                                    },
                                    "modelId": {
                                        "type": "string"
                                    },
                                    "resultID": {
                                        "type": "string"
                                    }
                                },
                                "annotations": [],
                                "type": "RestResource",
                                "schema": []
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/blob')]",
                            "type": "Microsoft.DataFactory/factories/datasets",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "linkedServiceName": {
                                    "referenceName": "blobStoreDoc",
                                    "type": "LinkedServiceReference"
                                },
                                "parameters": {
                                    "container": {
                                        "type": "string",
                                        "defaultValue": "na"
                                    },
                                    "endpoint": {
                                        "type": "string",
                                        "defaultValue": "na"
                                    }
                                },
                                "annotations": [],
                                "type": "Binary",
                                "typeProperties": {
                                    "location": {
                                        "type": "AzureBlobStorageLocation",
                                        "container": {
                                            "value": "@dataset().container",
                                            "type": "Expression"
                                        }
                                    }
                                }
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/linkedServices/blobStoreDoc')]"
                            ]
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/blobfile')]",
                            "type": "Microsoft.DataFactory/factories/datasets",
                            "apiVersion": "2018-06-01",
                            "properties": {
                                "linkedServiceName": {
                                    "referenceName": "blobStoreDoc",
                                    "type": "LinkedServiceReference"
                                },
                                "parameters": {
                                    "container": {
                                        "type": "string",
                                        "defaultValue": "na"
                                    },
                                    "filename": {
                                        "type": "string",
                                        "defaultValue": "na"
                                    },
                                    "folder": {
                                        "type": "string",
                                        "defaultValue": "na"
                                    }
                                },
                                "annotations": [],
                                "type": "Binary",
                                "typeProperties": {
                                    "location": {
                                        "type": "AzureBlobStorageLocation",
                                        "fileName": {
                                            "value": "@dataset().filename",
                                            "type": "Expression"
                                        },
                                        "container": {
                                            "value": "@dataset().container",
                                            "type": "Expression"
                                        }
                                    }
                                }
                            },
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/linkedServices/blobStoreDoc')]"
                            ]
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/tempfile')]",
                            "type": "Microsoft.DataFactory/factories/datasets",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/linkedServices/blobStoreDoc')]"
                            ],
                            "properties": {
                                "linkedServiceName": {
                                    "referenceName": "blobStoreDoc",
                                    "type": "LinkedServiceReference"
                                },
                                "parameters": {
                                    "filename": {
                                        "type": "string",
                                        "defaultValue": "tempfile.txt"
                                    }
                                },
                                "annotations": [],
                                "type": "Json",
                                "typeProperties": {
                                    "location": {
                                        "type": "AzureBlobStorageLocation",
                                        "fileName": {
                                            "value": "@dataset().filename",
                                            "type": "Expression"
                                        },
                                        "container": "temp"
                                    }
                                },
                                "schema": {}
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/GPT4Deployment')]",
                            "type": "Microsoft.DataFactory/factories/linkedServices",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[variables('factoryId')]",
                                "[concat(variables('factoryId'), '/integrationRuntimes/AzureIntegrationRuntime')]"
                            ],
                            "properties": {
                                "parameters": {
                                    "open_ai_base": {
                                        "type": "string",
                                        "defaultValue": "[parameters('azureOpenAiEndpoint')]"
                                    },
                                    "gpt4deployment": {
                                        "type": "string",
                                        "defaultValue": "[parameters('gpt4DeploymentName')]"
                                    }
                                },
                                "annotations": [],
                                "type": "RestService",
                                "typeProperties": {
                                    "url": "[parameters('GPT4Deployment_properties_typeProperties_url')]",
                                    "enableServerCertificateValidation": true,
                                    "authenticationType": "ManagedServiceIdentity",
                                    "aadResourceId": "[variables('msiAuthEndpoint')]"
                                },
                                "connectVia": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), variables('managedIntegrationRuntime'), json('null'))]"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/CosmosDbNoSql')]",
                            "type": "Microsoft.DataFactory/factories/linkedServices",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[variables('factoryId')]",
                                "[concat(variables('factoryId'), '/integrationRuntimes/AzureIntegrationRuntime')]"
                            ],
                            "properties": {
                                "annotations": [],
                                "type": "CosmosDb",
                                "typeProperties": {
                                    "accountEndpoint": "[parameters('cosmosDbNoSqlEndpoint')]",
                                    "database": "[parameters('CosmosDbNoSqlDatabase')]"
                                },
                                "connectVia": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), variables('managedIntegrationRuntime'), json('null'))]"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/onYourData')]",
                            "type": "Microsoft.DataFactory/factories/linkedServices",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[variables('factoryId')]",
                                "[concat(variables('factoryId'), '/integrationRuntimes/AzureIntegrationRuntime')]"
                            ],
                            "properties": {
                                "parameters": {
                                    "documentIntelligenceAPI": {
                                        "type": "string"
                                    },
                                    "modelId": {
                                        "type": "string"
                                    },
                                    "resultID": {
                                        "type": "string"
                                    }
                                },
                                "annotations": [],
                                "type": "RestService",
                                "typeProperties": {
                                    "url": "[parameters('onYourData_properties_typeProperties_url')]",
                                    "enableServerCertificateValidation": true,
                                    "authenticationType": "ManagedServiceIdentity",
                                    "aadResourceId": "[variables('msiAuthEndpoint')]"
                                },
                                "connectVia": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), variables('managedIntegrationRuntime'), json('null'))]"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/blobStoreDoc')]",
                            "type": "Microsoft.DataFactory/factories/linkedServices",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[variables('factoryId')]",
                                "[concat(variables('factoryId'), '/integrationRuntimes/AzureIntegrationRuntime')]"
                            ],
                            "properties": {
                                "annotations": [],
                                "type": "AzureBlobStorage",
                                "typeProperties": {
                                    "serviceEndpoint": "[parameters('storageAccountBlobEndpoint')]",
                                    "accountKind": "StorageV2"
                                },
                                "connectVia": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), variables('managedIntegrationRuntime'), json('null'))]"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/triggerDocBlob')]",
                            "type": "Microsoft.DataFactory/factories/triggers",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/pipelines/singleAnalyzeDocument')]"
                            ],
                            "properties": {
                                "annotations": [],
                                "runtimeState": "Started",
                                "pipelines": [
                                    {
                                        "pipelineReference": {
                                            "referenceName": "singleAnalyzeDocument",
                                            "type": "PipelineReference"
                                        },
                                        "parameters": {
                                            "fileName": "[parameters('triggerDocBlob_properties_singleAnalyzeDocument_parameters_fileName')]",
                                            "openai_api_base": "[parameters('azureOpenAiEndpoint')]",
                                            "sys_message": "[parameters('systemMessage')]",
                                            "user_prompt": "[parameters('userPrompt')]",
                                            "storageaccounturl": "[parameters('storageAccountBlobEndpoint')]",
                                            "storageAccountContainer": "[parameters('storageAccountContainer')]",
                                            "temperature": "[parameters('temperature')]",
                                            "top_p": "[parameters('topP')]",
                                            "cosmosaccount": "[parameters('cosmosDbNoSqlEndpoint')]",
                                            "cosmosdb": "[parameters('cosmosDbNoSqlDatabase')]",
                                            "cosmoscontainer": "[parameters('cosmosDbNoSqlContainer')]",
                                            "documentIntelligenceAPI": "[parameters('documentIntelligenceEndpoint')]",
                                            "modelId": "[parameters('documentIntelligenceModelId')]",
                                            "searchServiceEndpoint": "[parameters('aiSearchServiceEndpoint')]",
                                            "embeddingDeploymentName": "[parameters('embeddingsDeploymentName')]",
                                            "storageAccountResourceId": "[parameters('storageAccountResourceId')]",
                                            "indexName": "[parameters('indexName')]"
                                        }
                                    }
                                ],
                                "type": "BlobEventsTrigger",
                                "typeProperties": {
                                    "blobPathBeginsWith": "/docs/blobs/",
                                    "ignoreEmptyBlobs": true,
                                    "scope": "[parameters('storageAccountResourceId')]",
                                    "events": [
                                        "Microsoft.Storage.BlobCreated"
                                    ]
                                }
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/singleAnalyzeDocument_withoutIntel')]",
                            "type": "Microsoft.DataFactory/factories/pipelines",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/datasets/AzureOpenAI')]",
                                "[concat(variables('factoryId'), '/datasets/CosmosGPTOutput')]"
                            ],
                            "properties": {
                                "activities": [
                                    {
                                        "name": "Check if success",
                                        "type": "IfCondition",
                                        "dependsOn": [
                                            {
                                                "activity": "Check and wait until ingestion complete_copy1_copy1",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "expression": {
                                                "value": "@equals(variables('ingestionStatus'),'succeeded')",
                                                "type": "Expression"
                                            },
                                            "ifFalseActivities": [
                                                {
                                                    "name": "Fail1",
                                                    "type": "Fail",
                                                    "dependsOn": [],
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "message": "Ingestion failed or timed out",
                                                        "errorCode": "500"
                                                    }
                                                }
                                            ],
                                            "ifTrueActivities": [
                                                {
                                                    "name": "Copy GPT4 Response to Cosmos",
                                                    "type": "Copy",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "source": {
                                                            "type": "RestSource",
                                                            "additionalColumns": [
                                                                {
                                                                    "name": "timestamp",
                                                                    "value": {
                                                                        "value": "@pipeline().TriggerTime",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "fileurl",
                                                                    "value": {
                                                                        "value": "@{pipeline().parameters.storageaccounturl}@{pipeline().parameters.storageAccountContainer}/@{pipeline().parameters.fileName}",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "filename",
                                                                    "value": {
                                                                        "value": "@pipeline().parameters.fileName",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "shortdate",
                                                                    "value": {
                                                                        "value": "@formatDateTime(pipeline().TriggerTime,'yyyy-MM-dd')",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "temperature",
                                                                    "value": {
                                                                        "value": "@replace(pipeline().parameters.temperature,'\"temperature:\"','\"\"')",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "top_p",
                                                                    "value": {
                                                                        "value": "@replace(pipeline().parameters.top_p,'\"top_p:\"','\"\"')",
                                                                        "type": "Expression"
                                                                    }
                                                                }
                                                            ],
                                                            "httpRequestTimeout": "00:05:00",
                                                            "requestInterval": "00.00:00:00.010",
                                                            "requestMethod": "POST",
                                                            "requestBody": {
                                                                "value": "{\n\"dataSources\": [\n    {\n        \"type\": \"AzureCognitiveSearch\",\n        \"parameters\": {\n            \"endpoint\": \"@{pipeline().parameters.searchServiceEndpoint}\",\n            \"queryType\": \"vectorSimpleHybrid\",\n            \"indexName\": \"@{pipeline().parameters.indexName}\",\n            \"embeddingDeploymentName\": \"@{pipeline().parameters.embeddingDeploymentName}\"\n        }\n    }\n],\n\"messages\": [\n    {\n        \"role\": \"system\",\n        \"content\": \"@{pipeline().parameters.sys_message}\"\n    },\n    {\n        \"role\": \"user\",\n        \"content\": \"@{pipeline().parameters.user_prompt}\"\n    }\n]\n}",
                                                                "type": "Expression"
                                                            },
                                                            "additionalHeaders": {
                                                                "Content-Type": "application/json"
                                                            },
                                                            "paginationRules": {
                                                                "supportRFC5988": "true"
                                                            }
                                                        },
                                                        "sink": {
                                                            "type": "CosmosDbSqlApiSink",
                                                            "writeBehavior": "insert"
                                                        },
                                                        "enableStaging": false,
                                                        "translator": {
                                                            "type": "TabularTranslator",
                                                            "mappings": [
                                                                {
                                                                    "source": {
                                                                        "path": "$['id']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "id"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['choices'][0]['message']['content']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "content"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['usage']['prompt_tokens']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "prompt_tokens"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['usage']['completion_tokens']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "completion_tokens"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['timestamp']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "timestamp"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['fileurl']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "orignalfileurl"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['filename']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "filename"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['shortdate']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "shortdate"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['temperature']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "temperature"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['temp_p']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "temp_p"
                                                                    }
                                                                }
                                                            ],
                                                            "collectionReference": ""
                                                        }
                                                    },
                                                    "inputs": [
                                                        {
                                                            "referenceName": "AzureOpenAI",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "openai_api_base": {
                                                                    "value": "@pipeline().parameters.openai_api_base",
                                                                    "type": "Expression"
                                                                },
                                                                "gpt4_deployment_name": {
                                                                    "value": "@pipeline().parameters.gpt4_deployment_name",
                                                                    "type": "Expression"
                                                                },
                                                                "relative_url": {
                                                                    "value": "@{pipeline().parameters.openai_api_base}openai/deployments/@{pipeline().parameters.gpt4_deployment_name}/extensions/chat/completions?api-version=2023-12-01-preview",
                                                                    "type": "Expression"
                                                                }
                                                            }
                                                        }
                                                    ],
                                                    "outputs": [
                                                        {
                                                            "referenceName": "CosmosGPTOutput",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "cosmosaccount": {
                                                                    "value": "@pipeline().parameters.cosmosaccount",
                                                                    "type": "Expression"
                                                                },
                                                                "cosmosdb": {
                                                                    "value": "@pipeline().parameters.cosmosdb",
                                                                    "type": "Expression"
                                                                },
                                                                "cosmoscontainer": {
                                                                    "value": "@pipeline().parameters.cosmoscontainer",
                                                                    "type": "Expression"
                                                                }
                                                            }
                                                        }
                                                    ]
                                                },
                                                {
                                                    "name": "Move file to processed container",
                                                    "type": "Copy",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "Copy GPT4 Response to Cosmos",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "source": {
                                                            "type": "BinarySource",
                                                            "storeSettings": {
                                                                "type": "AzureBlobStorageReadSettings",
                                                                "recursive": true,
                                                                "deleteFilesAfterCompletion": true
                                                            },
                                                            "formatSettings": {
                                                                "type": "BinaryReadSettings"
                                                            }
                                                        },
                                                        "sink": {
                                                            "type": "BinarySink",
                                                            "storeSettings": {
                                                                "type": "AzureBlobStorageWriteSettings"
                                                            }
                                                        },
                                                        "enableStaging": false
                                                    },
                                                    "inputs": [
                                                        {
                                                            "referenceName": "blobfile",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "container": {
                                                                    "value": "@pipeline().parameters.storageaccountcontainer",
                                                                    "type": "Expression"
                                                                },
                                                                "filename": {
                                                                    "value": "@pipeline().parameters.fileName",
                                                                    "type": "Expression"
                                                                },
                                                                "folder": " "
                                                            }
                                                        }
                                                    ],
                                                    "outputs": [
                                                        {
                                                            "referenceName": "blobfile",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "container": "processed",
                                                                "filename": {
                                                                    "value": "@pipeline().parameters.fileName",
                                                                    "type": "Expression"
                                                                }
                                                            }
                                                        }
                                                    ]
                                                }
                                            ]
                                        }
                                    },
                                    {
                                        "name": "Check and wait until ingestion complete_copy1_copy1",
                                        "type": "Until",
                                        "dependsOn": [
                                            {
                                                "activity": "Ingest to AI Search",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "expression": {
                                                "value": "@or(equals(variables('ingestionStatus'),'succeeded'),equals(variables('ingestionStatus'),'Failed'))",
                                                "type": "Expression"
                                            },
                                            "activities": [
                                                {
                                                    "name": "Check if OpenAI completed",
                                                    "type": "IfCondition",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "Set OpenAI ingestion status",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "expression": {
                                                            "value": "@or(equals(variables('ingestionStatus'),'notRunning'),equals(variables('ingestionStatus'),'running'))",
                                                            "type": "Expression"
                                                        },
                                                        "ifFalseActivities": [
                                                            {
                                                                "name": "Wait and check OpenAI again in a bit",
                                                                "type": "Wait",
                                                                "dependsOn": [],
                                                                "userProperties": [],
                                                                "typeProperties": {
                                                                    "waitTimeInSeconds": 10
                                                                }
                                                            }
                                                        ]
                                                    }
                                                },
                                                {
                                                    "name": "Set OpenAI ingestion status",
                                                    "type": "SetVariable",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "see if openai ingestion completed",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "policy": {
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "variableName": "ingestionStatus",
                                                        "value": {
                                                            "value": "@activity('see if openai ingestion completed').output.status",
                                                            "type": "Expression"
                                                        }
                                                    }
                                                },
                                                {
                                                    "name": "see if openai ingestion completed",
                                                    "type": "WebActivity",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "method": "GET",
                                                        "url": {
                                                            "value": "@{pipeline().parameters.openai_api_base}openai/extensions/on-your-data/ingestion-jobs/@{pipeline().parameters.indexName}?api-version=2023-10-01-preview",
                                                            "type": "Expression"
                                                        },
                                                        "authentication": {
                                                            "type": "MSI",
                                                            "resource": "[variables('msiAuthEndpoint')]"
                                                        }
                                                    }
                                                }
                                            ],
                                            "timeout": "0.00:15:00"
                                        }
                                    },
                                    {
                                        "name": "Ingest to AI Search",
                                        "type": "WebActivity",
                                        "dependsOn": [],
                                        "policy": {
                                            "timeout": "0.12:00:00",
                                            "retry": 0,
                                            "retryIntervalInSeconds": 30,
                                            "secureOutput": false,
                                            "secureInput": false
                                        },
                                        "userProperties": [],
                                        "typeProperties": {
                                            "method": "PUT",
                                            "headers": {
                                                "Content-Type": "application/json",
                                                "storageEndpoint": {
                                                    "value": "@pipeline().parameters.storageaccounturl",
                                                    "type": "Expression"
                                                },
                                                "storageConnectionString": {
                                                    "value": "ResourceId=@{pipeline().parameters.storageAccountResourceId}",
                                                    "type": "Expression"
                                                },
                                                "storageContainer": {
                                                    "value": "@pipeline().parameters.storageAccountContainer",
                                                    "type": "Expression"
                                                },
                                                "searchServiceEndpoint": {
                                                    "value": "@pipeline().parameters.searchServiceEndpoint",
                                                    "type": "Expression"
                                                },
                                                "embeddingDeploymentName": {
                                                    "value": "@pipeline().parameters.embeddingDeploymentName",
                                                    "type": "Expression"
                                                }
                                            },
                                            "url": {
                                                "value": "@{pipeline().parameters.openai_api_base}openai/extensions/on-your-data/ingestion-jobs/@{pipeline().parameters.indexName}?api-version=2023-10-01-preview",
                                                "type": "Expression"
                                            },
                                            "body": {
                                                "completionAction": "keepAllAssets",
                                                "dataRefreshIntervalInMinutes": 60,
                                                "chunkSize": 1024
                                            },
                                            "authentication": {
                                                "type": "MSI",
                                                "resource": "[variables('msiAuthEndpoint')]"
                                            }
                                        }
                                    }
                                ],
                                "policy": {
                                    "elapsedTimeMetric": {}
                                },
                                "parameters": {
                                    "fileName": {
                                        "type": "string",
                                        "defaultValue": ""
                                    },
                                    "gpt4_deployment_name": {
                                        "type": "string",
                                        "defaultValue": "[parameters('gpt4DeploymentName')]"
                                    },
                                    "openai_api_base": {
                                        "type": "string",
                                        "defaultValue": "[parameters('azureOpenAiEndpoint')]"
                                    },
                                    "sys_message": {
                                        "type": "string",
                                        "defaultValue": "[parameters('systemMessage')]"
                                    },
                                    "user_prompt": {
                                        "type": "string",
                                        "defaultValue": "[parameters('userPrompt')]"
                                    },
                                    "storageaccounturl": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountBlobEndpoint')]"
                                    },
                                    "storageAccountContainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountContainer')]"
                                    },
                                    "temperature": {
                                        "type": "string",
                                        "defaultValue": "[parameters('temperature')]"
                                    },
                                    "top_p": {
                                        "type": "string",
                                        "defaultValue": "[parameters('topP')]"
                                    },
                                    "cosmosaccount": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlEndpoint')]"
                                    },
                                    "cosmosdb": {
                                        "type": "string",
                                        "defaultValue": "[parameters('CosmosDbNoSqlDatabase')]"
                                    },
                                    "cosmoscontainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlContainer')]"
                                    },
                                    "searchServiceEndpoint": {
                                        "type": "string",
                                        "defaultValue": "[parameters('aiSearchServiceEndpoint')]"
                                    },
                                    "embeddingDeploymentName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('embeddingsDeploymentName')]"
                                    },
                                    "storageAccountResourceId": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountResourceId')]"
                                    },
                                    "indexName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('indexName')]"
                                    }
                                },
                                "variables": {
                                    "indexName": {
                                        "type": "String"
                                    },
                                    "indexID": {
                                        "type": "String"
                                    },
                                    "ingestionStatus": {
                                        "type": "String",
                                        "defaultValue": "Running"
                                    },
                                    "processedfolder": {
                                        "type": "String"
                                    },
                                    "resultID": {
                                        "type": "String"
                                    },
                                    "documentIdObj": {
                                        "type": "Array"
                                    }
                                },
                                "annotations": [],
                                "lastPublishTime": "2024-03-08T08:27:46Z"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/singleAnalyzeDocument')]",
                            "type": "Microsoft.DataFactory/factories/pipelines",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/datasets/AzureOpenAI')]",
                                "[concat(variables('factoryId'), '/datasets/CosmosGPTOutput')]",
                                "[concat(variables('factoryId'), '/datasets/onYourData')]",
                                "[concat(variables('factoryId'), '/datasets/tempfile')]"
                            ],
                            "properties": {
                                "activities": [
                                    {
                                        "name": "Check and wait until ingestion complete",
                                        "type": "Until",
                                        "dependsOn": [
                                            {
                                                "activity": "Set resultID",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "expression": {
                                                "value": "@or(equals(variables('ingestionStatus'),'succeeded'),equals(variables('ingestionStatus'),'Failed'))",
                                                "type": "Expression"
                                            },
                                            "activities": [
                                                {
                                                    "name": "Check if completed",
                                                    "type": "IfCondition",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "Set ingestion status",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "expression": {
                                                            "value": "@or(equals(variables('ingestionStatus'),'succeeded'),equals(variables('ingestionStatus'),'Failed'))",
                                                            "type": "Expression"
                                                        },
                                                        "ifFalseActivities": [
                                                            {
                                                                "name": "Wait and check again in a bit",
                                                                "type": "Wait",
                                                                "dependsOn": [],
                                                                "userProperties": [],
                                                                "typeProperties": {
                                                                    "waitTimeInSeconds": 10
                                                                }
                                                            }
                                                        ],
                                                        "ifTrueActivities": [
                                                            {
                                                                "name": "create file",
                                                                "type": "Copy",
                                                                "dependsOn": [],
                                                                "policy": {
                                                                    "timeout": "0.12:00:00",
                                                                    "retry": 0,
                                                                    "retryIntervalInSeconds": 30,
                                                                    "secureOutput": false,
                                                                    "secureInput": false
                                                                },
                                                                "userProperties": [],
                                                                "typeProperties": {
                                                                    "source": {
                                                                        "type": "RestSource",
                                                                        "httpRequestTimeout": "00:01:40",
                                                                        "requestInterval": "00.00:00:00.010",
                                                                        "requestMethod": "GET",
                                                                        "paginationRules": {
                                                                            "supportRFC5988": "true"
                                                                        }
                                                                    },
                                                                    "sink": {
                                                                        "type": "JsonSink",
                                                                        "storeSettings": {
                                                                            "type": "AzureBlobStorageWriteSettings"
                                                                        },
                                                                        "formatSettings": {
                                                                            "type": "JsonWriteSettings"
                                                                        }
                                                                    },
                                                                    "enableStaging": false,
                                                                    "translator": {
                                                                        "type": "TabularTranslator",
                                                                        "mappings": [
                                                                            {
                                                                                "source": {
                                                                                    "path": "$['analyzeResult']['content']"
                                                                                },
                                                                                "sink": {
                                                                                    "path": "$['analyzeResult']['content']"
                                                                                }
                                                                            }
                                                                        ]
                                                                    }
                                                                },
                                                                "inputs": [
                                                                    {
                                                                        "referenceName": "onYourData",
                                                                        "type": "DatasetReference",
                                                                        "parameters": {
                                                                            "documentIntelligenceAPI": {
                                                                                "value": "@pipeline().parameters.documentIntelligenceAPI",
                                                                                "type": "Expression"
                                                                            },
                                                                            "modelId": {
                                                                                "value": "@pipeline().parameters.modelId",
                                                                                "type": "Expression"
                                                                            },
                                                                            "resultID": {
                                                                                "value": "@variables('resultID')",
                                                                                "type": "Expression"
                                                                            }
                                                                        }
                                                                    }
                                                                ],
                                                                "outputs": [
                                                                    {
                                                                        "referenceName": "tempfile",
                                                                        "type": "DatasetReference",
                                                                        "parameters": {
                                                                            "filename": {
                                                                                "value": "@{pipeline().parameters.fileName}.txt",
                                                                                "type": "Expression"
                                                                            }
                                                                        }
                                                                    }
                                                                ]
                                                            }
                                                        ]
                                                    }
                                                },
                                                {
                                                    "name": "Set ingestion status",
                                                    "type": "SetVariable",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "see if ingestion completed",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "policy": {
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "variableName": "ingestionStatus",
                                                        "value": {
                                                            "value": "@activity('see if ingestion completed').output.status",
                                                            "type": "Expression"
                                                        }
                                                    }
                                                },
                                                {
                                                    "name": "see if ingestion completed",
                                                    "type": "WebActivity",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "method": "GET",
                                                        "url": {
                                                            "value": "@{pipeline().parameters.documentIntelligenceAPI}documentintelligence/documentModels/@{pipeline().parameters.modelId}/analyzeResults/@{variables('resultID')}?api-version=2023-10-31-preview\n",
                                                            "type": "Expression"
                                                        },
                                                        "authentication": {
                                                            "type": "MSI",
                                                            "resource": "[variables('msiAuthEndpoint')]"
                                                        }
                                                    }
                                                }
                                            ],
                                            "timeout": "0.00:15:00"
                                        }
                                    },
                                    {
                                        "name": "Check if success",
                                        "type": "IfCondition",
                                        "dependsOn": [
                                            {
                                                "activity": "Check and wait until ingestion complete_copy1_copy1",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "expression": {
                                                "value": "@equals(variables('ingestionStatus'),'succeeded')",
                                                "type": "Expression"
                                            },
                                            "ifFalseActivities": [
                                                {
                                                    "name": "Fail1",
                                                    "type": "Fail",
                                                    "dependsOn": [],
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "message": "Ingestion failed or timed out",
                                                        "errorCode": "500"
                                                    }
                                                }
                                            ],
                                            "ifTrueActivities": [
                                                {
                                                    "name": "Copy GPT4 Response to Cosmos",
                                                    "type": "Copy",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "source": {
                                                            "type": "RestSource",
                                                            "additionalColumns": [
                                                                {
                                                                    "name": "timestamp",
                                                                    "value": {
                                                                        "value": "@pipeline().TriggerTime",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "fileurl",
                                                                    "value": {
                                                                        "value": "@{pipeline().parameters.storageaccounturl}@{pipeline().parameters.storageAccountContainer}/@{pipeline().parameters.fileName}",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "filename",
                                                                    "value": {
                                                                        "value": "@pipeline().parameters.fileName",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "shortdate",
                                                                    "value": {
                                                                        "value": "@formatDateTime(pipeline().TriggerTime,'yyyy-MM-dd')",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "temperature",
                                                                    "value": {
                                                                        "value": "@replace(pipeline().parameters.temperature,'\"temperature:\"','\"\"')",
                                                                        "type": "Expression"
                                                                    }
                                                                },
                                                                {
                                                                    "name": "top_p",
                                                                    "value": {
                                                                        "value": "@replace(pipeline().parameters.top_p,'\"top_p:\"','\"\"')",
                                                                        "type": "Expression"
                                                                    }
                                                                }
                                                            ],
                                                            "httpRequestTimeout": "00:05:00",
                                                            "requestInterval": "00.00:00:00.010",
                                                            "requestMethod": "POST",
                                                            "requestBody": {
                                                                "value": "{\n\"dataSources\": [\n    {\n        \"type\": \"AzureCognitiveSearch\",\n        \"parameters\": {\n            \"endpoint\": \"@{pipeline().parameters.searchServiceEndpoint}\",\n            \"queryType\": \"vectorSimpleHybrid\",\n            \"indexName\": \"@{pipeline().parameters.indexName}\",\n            \"embeddingDeploymentName\": \"@{pipeline().parameters.embeddingDeploymentName}\"\n        }\n    }\n],\n\"messages\": [\n    {\n        \"role\": \"system\",\n        \"content\": \"@{pipeline().parameters.sys_message}\"\n    },\n    {\n        \"role\": \"user\",\n        \"content\": \"@{pipeline().parameters.user_prompt}\"\n    }\n]\n}",
                                                                "type": "Expression"
                                                            },
                                                            "additionalHeaders": {
                                                                "Content-Type": "application/json"
                                                            },
                                                            "paginationRules": {
                                                                "supportRFC5988": "true"
                                                            }
                                                        },
                                                        "sink": {
                                                            "type": "CosmosDbSqlApiSink",
                                                            "writeBehavior": "insert"
                                                        },
                                                        "enableStaging": false,
                                                        "translator": {
                                                            "type": "TabularTranslator",
                                                            "mappings": [
                                                                {
                                                                    "source": {
                                                                        "path": "$['id']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "id"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['choices'][0]['message']['content']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "content"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['usage']['prompt_tokens']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "prompt_tokens"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['usage']['completion_tokens']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "completion_tokens"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['timestamp']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "timestamp"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['fileurl']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "orignalfileurl"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['filename']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "filename"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['shortdate']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "shortdate"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['temperature']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "temperature"
                                                                    }
                                                                },
                                                                {
                                                                    "source": {
                                                                        "path": "$['temp_p']"
                                                                    },
                                                                    "sink": {
                                                                        "path": "temp_p"
                                                                    }
                                                                }
                                                            ],
                                                            "collectionReference": ""
                                                        }
                                                    },
                                                    "inputs": [
                                                        {
                                                            "referenceName": "AzureOpenAI",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "openai_api_base": {
                                                                    "value": "@pipeline().parameters.openai_api_base",
                                                                    "type": "Expression"
                                                                },
                                                                "gpt4_deployment_name": {
                                                                    "value": "@pipeline().parameters.gpt4_deployment_name",
                                                                    "type": "Expression"
                                                                },
                                                                "relative_url": {
                                                                    "value": "@{pipeline().parameters.openai_api_base}openai/deployments/@{pipeline().parameters.gpt4_deployment_name}/extensions/chat/completions?api-version=2023-12-01-preview",
                                                                    "type": "Expression"
                                                                }
                                                            }
                                                        }
                                                    ],
                                                    "outputs": [
                                                        {
                                                            "referenceName": "CosmosGPTOutput",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "cosmosaccount": {
                                                                    "value": "@pipeline().parameters.cosmosaccount",
                                                                    "type": "Expression"
                                                                },
                                                                "cosmosdb": {
                                                                    "value": "@pipeline().parameters.cosmosdb",
                                                                    "type": "Expression"
                                                                },
                                                                "cosmoscontainer": {
                                                                    "value": "@pipeline().parameters.cosmoscontainer",
                                                                    "type": "Expression"
                                                                }
                                                            }
                                                        }
                                                    ]
                                                },
                                                {
                                                    "name": "Move file to processed container",
                                                    "type": "Copy",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "Copy GPT4 Response to Cosmos",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "source": {
                                                            "type": "BinarySource",
                                                            "storeSettings": {
                                                                "type": "AzureBlobStorageReadSettings",
                                                                "recursive": false,
                                                                "deleteFilesAfterCompletion": true
                                                            },
                                                            "formatSettings": {
                                                                "type": "BinaryReadSettings"
                                                            }
                                                        },
                                                        "sink": {
                                                            "type": "BinarySink",
                                                            "storeSettings": {
                                                                "type": "AzureBlobStorageWriteSettings"
                                                            }
                                                        },
                                                        "enableStaging": false
                                                    },
                                                    "inputs": [
                                                        {
                                                            "referenceName": "blobfile",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "container": {
                                                                    "value": "@pipeline().parameters.storageAccountContainer",
                                                                    "type": "Expression"
                                                                },
                                                                "filename": {
                                                                    "value": "@pipeline().parameters.fileName",
                                                                    "type": "Expression"
                                                                },
                                                                "folder": " "
                                                            }
                                                        }
                                                    ],
                                                    "outputs": [
                                                        {
                                                            "referenceName": "blobfile",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "container": "processed",
                                                                "filename": {
                                                                    "value": "@pipeline().parameters.fileName",
                                                                    "type": "Expression"
                                                                }
                                                            }
                                                        }
                                                    ]
                                                },
                                                {
                                                    "name": "Move temp file to processed container",
                                                    "type": "Copy",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "Copy GPT4 Response to Cosmos",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "source": {
                                                            "type": "BinarySource",
                                                            "storeSettings": {
                                                                "type": "AzureBlobStorageReadSettings",
                                                                "recursive": false,
                                                                "deleteFilesAfterCompletion": true
                                                            },
                                                            "formatSettings": {
                                                                "type": "BinaryReadSettings"
                                                            }
                                                        },
                                                        "sink": {
                                                            "type": "BinarySink",
                                                            "storeSettings": {
                                                                "type": "AzureBlobStorageWriteSettings"
                                                            }
                                                        },
                                                        "enableStaging": false
                                                    },
                                                    "inputs": [
                                                        {
                                                            "referenceName": "blobfile",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "container": "temp",
                                                                "filename": {
                                                                    "value": "@{pipeline().parameters.fileName}.txt",
                                                                    "type": "Expression"
                                                                },
                                                                "folder": " "
                                                            }
                                                        }
                                                    ],
                                                    "outputs": [
                                                        {
                                                            "referenceName": "blobfile",
                                                            "type": "DatasetReference",
                                                            "parameters": {
                                                                "container": "processed",
                                                                "filename": {
                                                                    "value": "@{pipeline().parameters.fileName}.txt",
                                                                    "type": "Expression"
                                                                },
                                                                "folder": "na"
                                                            }
                                                        }
                                                    ]
                                                }
                                            ]
                                        }
                                    },
                                    {
                                        "name": "Set resultID",
                                        "type": "SetVariable",
                                        "dependsOn": [
                                            {
                                                "activity": "Ingest document",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "policy": {
                                            "secureOutput": false,
                                            "secureInput": false
                                        },
                                        "userProperties": [],
                                        "typeProperties": {
                                            "variableName": "resultID",
                                            "value": {
                                                "value": "@{activity('Ingest document').output.ADFWebActivityResponseHeaders['apim-request-id']}",
                                                "type": "Expression"
                                            }
                                        }
                                    },
                                    {
                                        "name": "Ingest document",
                                        "type": "WebActivity",
                                        "dependsOn": [],
                                        "policy": {
                                            "timeout": "0.12:00:00",
                                            "retry": 0,
                                            "retryIntervalInSeconds": 30,
                                            "secureOutput": false,
                                            "secureInput": false
                                        },
                                        "userProperties": [],
                                        "typeProperties": {
                                            "method": "POST",
                                            "headers": {
                                                "Content-Type": "application/json"
                                            },
                                            "url": {
                                                "value": "@{pipeline().parameters.documentIntelligenceAPI}documentintelligence/documentModels/prebuilt-layout:analyze?_overload=analyzeDocument&api-version=2023-10-31-preview&outputContentFormat=markdown",
                                                "type": "Expression"
                                            },
                                            "body": {
                                                "value": "{\"urlSource\":\"@{pipeline().parameters.storageaccounturl}@{pipeline().parameters.storageAccountContainer}/@{pipeline().parameters.fileName}\"}",
                                                "type": "Expression"
                                            },
                                            "authentication": {
                                                "type": "MSI",
                                                "resource": "[variables('msiAuthEndpoint')]"
                                            }
                                        }
                                    },
                                    {
                                        "name": "If Condition AI Search",
                                        "type": "IfCondition",
                                        "dependsOn": [
                                            {
                                                "activity": "Check and wait until ingestion complete",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "expression": {
                                                "value": "@equals(variables('ingestionStatus'),'succeeded')",
                                                "type": "Expression"
                                            },
                                            "ifFalseActivities": [
                                                {
                                                    "name": "Fail2",
                                                    "type": "Fail",
                                                    "dependsOn": [],
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "message": "Ingestion failed or timed out",
                                                        "errorCode": "500"
                                                    }
                                                }
                                            ],
                                            "ifTrueActivities": [
                                                {
                                                    "name": "Ingest to AI Search",
                                                    "type": "WebActivity",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "method": "PUT",
                                                        "headers": {
                                                            "Content-Type": "application/json",
                                                            "storageEndpoint": {
                                                                "value": "@pipeline().parameters.storageaccounturl",
                                                                "type": "Expression"
                                                            },
                                                            "storageConnectionString": {
                                                                "value": "ResourceId=@{pipeline().parameters.storageAccountResourceId}",
                                                                "type": "Expression"
                                                            },
                                                            "storageContainer": "temp",
                                                            "searchServiceEndpoint": {
                                                                "value": "@pipeline().parameters.searchServiceEndpoint",
                                                                "type": "Expression"
                                                            },
                                                            "embeddingDeploymentName": {
                                                                "value": "@pipeline().parameters.embeddingDeploymentName",
                                                                "type": "Expression"
                                                            }
                                                        },
                                                        "url": {
                                                            "value": "@{pipeline().parameters.openai_api_base}openai/extensions/on-your-data/ingestion-jobs/@{pipeline().parameters.indexName}?api-version=2023-10-01-preview",
                                                            "type": "Expression"
                                                        },
                                                        "body": {
                                                            "completionAction": "keepAllAssets",
                                                            "dataRefreshIntervalInMinutes": 60,
                                                            "chunkSize": 1024
                                                        },
                                                        "authentication": {
                                                            "type": "MSI",
                                                            "resource": "[variables('msiAuthEndpoint')]"
                                                        }
                                                    }
                                                }
                                            ]
                                        }
                                    },
                                    {
                                        "name": "Check and wait until ingestion complete_copy1_copy1",
                                        "type": "Until",
                                        "dependsOn": [
                                            {
                                                "activity": "If Condition AI Search",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "expression": {
                                                "value": "@or(equals(variables('ingestionStatus'),'succeeded'),equals(variables('ingestionStatus'),'Failed'))",
                                                "type": "Expression"
                                            },
                                            "activities": [
                                                {
                                                    "name": "Check if OpenAI completed",
                                                    "type": "IfCondition",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "Set OpenAI ingestion status",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "expression": {
                                                            "value": "@or(equals(variables('ingestionStatus'),'notRunning'),equals(variables('ingestionStatus'),'running'))",
                                                            "type": "Expression"
                                                        },
                                                        "ifFalseActivities": [
                                                            {
                                                                "name": "Wait and check OpenAI again in a bit",
                                                                "type": "Wait",
                                                                "dependsOn": [],
                                                                "userProperties": [],
                                                                "typeProperties": {
                                                                    "waitTimeInSeconds": 10
                                                                }
                                                            }
                                                        ]
                                                    }
                                                },
                                                {
                                                    "name": "Set OpenAI ingestion status",
                                                    "type": "SetVariable",
                                                    "dependsOn": [
                                                        {
                                                            "activity": "see if openai ingestion completed",
                                                            "dependencyConditions": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    ],
                                                    "policy": {
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "variableName": "ingestionStatus",
                                                        "value": {
                                                            "value": "@activity('see if openai ingestion completed').output.status",
                                                            "type": "Expression"
                                                        }
                                                    }
                                                },
                                                {
                                                    "name": "see if openai ingestion completed",
                                                    "type": "WebActivity",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "timeout": "0.12:00:00",
                                                        "retry": 0,
                                                        "retryIntervalInSeconds": 30,
                                                        "secureOutput": false,
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "method": "GET",
                                                        "url": {
                                                            "value": "@{pipeline().parameters.openai_api_base}openai/extensions/on-your-data/ingestion-jobs/@{pipeline().parameters.indexName}?api-version=2023-10-01-preview",
                                                            "type": "Expression"
                                                        },
                                                        "authentication": {
                                                            "type": "MSI",
                                                            "resource": "[variables('msiAuthEndpoint')]"
                                                        }
                                                    }
                                                }
                                            ],
                                            "timeout": "0.00:15:00"
                                        }
                                    }
                                ],
                                "policy": {
                                    "elapsedTimeMetric": {}
                                },
                                "parameters": {
                                    "fileName": {
                                        "type": "string",
                                        "defaultValue": ""
                                    },
                                    "gpt4_deployment_name": {
                                        "type": "string",
                                        "defaultValue": "[parameters('gpt4DeploymentName')]"
                                    },
                                    "openai_api_base": {
                                        "type": "string",
                                        "defaultValue": "[parameters('azureOpenAiEndpoint')]"
                                    },
                                    "sys_message": {
                                        "type": "string",
                                        "defaultValue": "[parameters('systemMessage')]"
                                    },
                                    "user_prompt": {
                                        "type": "string",
                                        "defaultValue": "[parameters('userPrompt')]"
                                    },
                                    "storageaccounturl": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountBlobEndpoint')]"
                                    },
                                    "storageAccountContainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountContainer')]"
                                    },
                                    "temperature": {
                                        "type": "string",
                                        "defaultValue": "[parameters('temperature')]"
                                    },
                                    "top_p": {
                                        "type": "string",
                                        "defaultValue": "[parameters('topP')]"
                                    },
                                    "cosmosaccount": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlEndpoint')]"
                                    },
                                    "cosmosdb": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlDatabase')]"
                                    },
                                    "cosmoscontainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlContainer')]"
                                    },
                                    "documentIntelligenceAPI": {
                                        "type": "string",
                                        "defaultValue": "[parameters('documentIntelligenceEndpoint')]"
                                    },
                                    "modelId": {
                                        "type": "string",
                                        "defaultValue": "[parameters('documentIntelligenceModelId')]"
                                    },
                                    "searchServiceEndpoint": {
                                        "type": "string",
                                        "defaultValue": "[parameters('aiSearchServiceEndpoint')]"
                                    },
                                    "embeddingDeploymentName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('embeddingsDeploymentName')]"
                                    },
                                    "storageAccountResourceId": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountResourceId')]"
                                    },
                                    "indexName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('indexName')]"
                                    }
                                },
                                "variables": {
                                    "indexName": {
                                        "type": "String"
                                    },
                                    "indexID": {
                                        "type": "String"
                                    },
                                    "ingestionStatus": {
                                        "type": "String",
                                        "defaultValue": "Running"
                                    },
                                    "processedfolder": {
                                        "type": "String"
                                    },
                                    "resultID": {
                                        "type": "String"
                                    },
                                    "documentIdObj": {
                                        "type": "Array"
                                    }
                                },
                                "annotations": [],
                                "lastPublishTime": "2024-03-08T08:27:46Z"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/batchAnalyzeDocuments_withoutIntel')]",
                            "type": "Microsoft.DataFactory/factories/pipelines",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/pipelines/singleAnalyzeDocument_withoutIntel')]"
                            ],
                            "properties": {
                                "activities": [
                                    {
                                        "name": "Get documents",
                                        "type": "GetMetadata",
                                        "dependsOn": [],
                                        "policy": {
                                            "timeout": "0.12:00:00",
                                            "retry": 0,
                                            "retryIntervalInSeconds": 30,
                                            "secureOutput": false,
                                            "secureInput": false
                                        },
                                        "userProperties": [],
                                        "typeProperties": {
                                            "dataset": {
                                                "referenceName": "blob",
                                                "type": "DatasetReference",
                                                "parameters": {
                                                    "container": {
                                                        "value": "@pipeline().parameters.storageaccountcontainer",
                                                        "type": "Expression"
                                                    },
                                                    "endpoint": {
                                                        "value": "@pipeline().parameters.storageaccounturl",
                                                        "type": "Expression"
                                                    }
                                                }
                                            },
                                            "fieldList": [
                                                "childItems"
                                            ],
                                            "storeSettings": {
                                                "type": "AzureBlobStorageReadSettings",
                                                "recursive": true,
                                                "enablePartitionDiscovery": false
                                            },
                                            "formatSettings": {
                                                "type": "BinaryReadSettings"
                                            }
                                        }
                                    },
                                    {
                                        "name": "ForEach Document File",
                                        "type": "ForEach",
                                        "dependsOn": [
                                            {
                                                "activity": "Get documents",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "items": {
                                                "value": "@activity('Get documents').output.childItems",
                                                "type": "Expression"
                                            },
                                            "isSequential": false,
                                            "activities": [
                                                {
                                                    "name": "childAnalyzeDocuments",
                                                    "type": "ExecutePipeline",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "pipeline": {
                                                            "referenceName": "singleAnalyzeDocument_withoutIntel",
                                                            "type": "PipelineReference"
                                                        },
                                                        "waitOnCompletion": true,
                                                        "parameters": {
                                                            "fileName": {
                                                                "value": "@item().name",
                                                                "type": "Expression"
                                                            },
                                                            "gpt4_deployment_name": {
                                                                "value": "@pipeline().parameters.gpt4_deployment_name",
                                                                "type": "Expression"
                                                            },
                                                            "openai_api_base": {
                                                                "value": "@pipeline().parameters.openAIAPI",
                                                                "type": "Expression"
                                                            },
                                                            "sys_message": {
                                                                "value": "@pipeline().parameters.sys_message",
                                                                "type": "Expression"
                                                            },
                                                            "user_prompt": {
                                                                "value": "@pipeline().parameters.user_prompt",
                                                                "type": "Expression"
                                                            },
                                                            "storageaccounturl": {
                                                                "value": "@pipeline().parameters.storageaccounturl",
                                                                "type": "Expression"
                                                            },
                                                            "storageAccountContainer": {
                                                                "value": "@pipeline().parameters.storageaccountcontainer",
                                                                "type": "Expression"
                                                            },
                                                            "temperature": {
                                                                "value": "@pipeline().parameters.temperature",
                                                                "type": "Expression"
                                                            },
                                                            "top_p": {
                                                                "value": "@pipeline().parameters.top_p",
                                                                "type": "Expression"
                                                            },
                                                            "cosmosaccount": {
                                                                "value": "@pipeline().parameters.cosmosaccount",
                                                                "type": "Expression"
                                                            },
                                                            "cosmosdb": {
                                                                "value": "@pipeline().parameters.cosmosdb",
                                                                "type": "Expression"
                                                            },
                                                            "cosmoscontainer": {
                                                                "value": "@pipeline().parameters.cosmoscontainer",
                                                                "type": "Expression"
                                                            },
                                                            "searchServiceEndpoint": {
                                                                "value": "@pipeline().parameters.searchServiceEndpoint",
                                                                "type": "Expression"
                                                            },
                                                            "embeddingDeploymentName": {
                                                                "value": "@pipeline().parameters.embeddingDeploymentName",
                                                                "type": "Expression"
                                                            },
                                                            "storageAccountResourceId": {
                                                                "value": "@pipeline().parameters.storageAccountResourceId",
                                                                "type": "Expression"
                                                            },
                                                            "indexName": {
                                                                "value": "@pipeline().parameters.aiSearchIndexName",
                                                                "type": "Expression"
                                                            }
                                                        }
                                                    }
                                                }
                                            ]
                                        }
                                    }
                                ],
                                "policy": {
                                    "elapsedTimeMetric": {}
                                },
                                "parameters": {
                                    "sys_message": {
                                        "type": "string",
                                        "defaultValue": "[parameters('systemMessage')]"
                                    },
                                    "user_prompt": {
                                        "type": "string",
                                        "defaultValue": "[parameters('userPrompt')]"
                                    },
                                    "storageaccounturl": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountBlobEndpoint')]"
                                    },
                                    "storageaccountcontainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountContainer')]"
                                    },
                                    "temperature": {
                                        "type": "string",
                                        "defaultValue": "[parameters('temperature')]"
                                    },
                                    "top_p": {
                                        "type": "string",
                                        "defaultValue": "[parameters('topP')]"
                                    },
                                    "cosmosaccount": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlEndpoint')]"
                                    },
                                    "cosmosdb": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlDatabase')]"
                                    },
                                    "cosmoscontainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlContainer')]"
                                    },
                                    "moderation": {
                                        "type": "bool",
                                        "defaultValue": false
                                    },
                                    "generateInsightIntervals": {
                                        "type": "bool",
                                        "defaultValue": false
                                    },
                                    "filterDefectedFrames": {
                                        "type": "bool",
                                        "defaultValue": false
                                    },
                                    "includeSpeechTranscript": {
                                        "type": "bool",
                                        "defaultValue": true
                                    },
                                    "openAIAPI": {
                                        "type": "string",
                                        "defaultValue": "[parameters('azureOpenAiEndpoint')]"
                                    },
                                    "gpt4_deployment_name": {
                                        "type": "string",
                                        "defaultValue": "[parameters('gpt4DeploymentName')]"
                                    },
                                    "embeddingDeploymentName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('embeddingsDeploymentName')]"
                                    },
                                    "searchServiceEndpoint": {
                                        "type": "string",
                                        "defaultValue": "[parameters('aiSearchServiceEndpoint')]"
                                    },
                                    "aiSearchIndexName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('indexName')]"
                                    },
                                    "storageAccountResourceId": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountResourceId')]"
                                    }
                                },
                                "variables": {
                                    "top_p": {
                                        "type": "String"
                                    },
                                    "temperature": {
                                        "type": "String"
                                    },
                                    "resultID": {
                                        "type": "String"
                                    }
                                },
                                "annotations": [],
                                "lastPublishTime": "2024-03-08T08:27:47Z"
                            }
                        },
                        {
                            "name": "[concat(variables('name-compliant-df'), '/batchAnalyzeDocuments')]",
                            "type": "Microsoft.DataFactory/factories/pipelines",
                            "apiVersion": "2018-06-01",
                            "dependsOn": [
                                "[concat(variables('factoryId'), '/pipelines/singleAnalyzeDocument')]"
                            ],
                            "properties": {
                                "activities": [
                                    {
                                        "name": "Get documents",
                                        "type": "GetMetadata",
                                        "dependsOn": [],
                                        "policy": {
                                            "timeout": "0.12:00:00",
                                            "retry": 0,
                                            "retryIntervalInSeconds": 30,
                                            "secureOutput": false,
                                            "secureInput": false
                                        },
                                        "userProperties": [],
                                        "typeProperties": {
                                            "dataset": {
                                                "referenceName": "blob",
                                                "type": "DatasetReference",
                                                "parameters": {
                                                    "container": {
                                                        "value": "@pipeline().parameters.storageaccountcontainer",
                                                        "type": "Expression"
                                                    },
                                                    "endpoint": {
                                                        "value": "@pipeline().parameters.storageaccounturl",
                                                        "type": "Expression"
                                                    }
                                                }
                                            },
                                            "fieldList": [
                                                "childItems"
                                            ],
                                            "storeSettings": {
                                                "type": "AzureBlobStorageReadSettings",
                                                "recursive": true,
                                                "enablePartitionDiscovery": false
                                            },
                                            "formatSettings": {
                                                "type": "BinaryReadSettings"
                                            }
                                        }
                                    },
                                    {
                                        "name": "ForEach Document File",
                                        "type": "ForEach",
                                        "dependsOn": [
                                            {
                                                "activity": "Get documents",
                                                "dependencyConditions": [
                                                    "Succeeded"
                                                ]
                                            }
                                        ],
                                        "userProperties": [],
                                        "typeProperties": {
                                            "items": {
                                                "value": "@activity('Get documents').output.childItems",
                                                "type": "Expression"
                                            },
                                            "isSequential": false,
                                            "activities": [
                                                {
                                                    "name": "Analyze Documents",
                                                    "type": "ExecutePipeline",
                                                    "dependsOn": [],
                                                    "policy": {
                                                        "secureInput": false
                                                    },
                                                    "userProperties": [],
                                                    "typeProperties": {
                                                        "pipeline": {
                                                            "referenceName": "singleAnalyzeDocument",
                                                            "type": "PipelineReference"
                                                        },
                                                        "waitOnCompletion": true,
                                                        "parameters": {
                                                            "fileName": {
                                                                "value": "@item().name",
                                                                "type": "Expression"
                                                            },
                                                            "gpt4_deployment_name": {
                                                                "value": "@pipeline().parameters.gpt4_deployment_name",
                                                                "type": "Expression"
                                                            },
                                                            "openai_api_base": {
                                                                "value": "@pipeline().parameters.openAIAPI",
                                                                "type": "Expression"
                                                            },
                                                            "sys_message": {
                                                                "value": "@pipeline().parameters.sys_message",
                                                                "type": "Expression"
                                                            },
                                                            "user_prompt": {
                                                                "value": "@pipeline().parameters.user_prompt",
                                                                "type": "Expression"
                                                            },
                                                            "storageaccounturl": {
                                                                "value": "@pipeline().parameters.storageaccounturl",
                                                                "type": "Expression"
                                                            },
                                                            "storageAccountContainer": {
                                                                "value": "@pipeline().parameters.storageaccountcontainer",
                                                                "type": "Expression"
                                                            },
                                                            "temperature": {
                                                                "value": "@pipeline().parameters.temperature",
                                                                "type": "Expression"
                                                            },
                                                            "top_p": {
                                                                "value": "@pipeline().parameters.top_p",
                                                                "type": "Expression"
                                                            },
                                                            "cosmosaccount": {
                                                                "value": "@pipeline().parameters.cosmosaccount",
                                                                "type": "Expression"
                                                            },
                                                            "cosmosdb": {
                                                                "value": "@pipeline().parameters.cosmosdb",
                                                                "type": "Expression"
                                                            },
                                                            "cosmoscontainer": {
                                                                "value": "@pipeline().parameters.cosmoscontainer",
                                                                "type": "Expression"
                                                            },
                                                            "documentIntelligenceAPI": {
                                                                "value": "@pipeline().parameters.documentIntelligenceAPI",
                                                                "type": "Expression"
                                                            },
                                                            "modelId": {
                                                                "value": "@pipeline().parameters.modelId",
                                                                "type": "Expression"
                                                            },
                                                            "searchServiceEndpoint": {
                                                                "value": "@pipeline().parameters.searchServiceEndpoint",
                                                                "type": "Expression"
                                                            },
                                                            "embeddingDeploymentName": {
                                                                "value": "@pipeline().parameters.embeddingDeploymentName",
                                                                "type": "Expression"
                                                            },
                                                            "storageAccountResourceId": {
                                                                "value": "@pipeline().parameters.storageAccountResourceId",
                                                                "type": "Expression"
                                                            },
                                                            "indexName": {
                                                                "value": "@pipeline().parameters.aiSearchIndexName",
                                                                "type": "Expression"
                                                            }
                                                        }
                                                    }
                                                }
                                            ]
                                        }
                                    }
                                ],
                                "policy": {
                                    "elapsedTimeMetric": {}
                                },
                                "parameters": {
                                    "sys_message": {
                                        "type": "string",
                                        "defaultValue": "[parameters('systemMessage')]"
                                    },
                                    "user_prompt": {
                                        "type": "string",
                                        "defaultValue": "[parameters('userPrompt')]"
                                    },
                                    "storageaccounturl": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountBlobEndpoint')]"
                                    },
                                    "storageaccountcontainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountContainer')]"
                                    },
                                    "temperature": {
                                        "type": "string",
                                        "defaultValue": "[parameters('temperature')]"
                                    },
                                    "top_p": {
                                        "type": "string",
                                        "defaultValue": "[parameters('topP')]"
                                    },
                                    "cosmosaccount": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlEndpoint')]"
                                    },
                                    "cosmosdb": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlDatabase')]"
                                    },
                                    "cosmoscontainer": {
                                        "type": "string",
                                        "defaultValue": "[parameters('cosmosDbNoSqlContainer')]"
                                    },
                                    "moderation": {
                                        "type": "bool",
                                        "defaultValue": false
                                    },
                                    "generateInsightIntervals": {
                                        "type": "bool",
                                        "defaultValue": false
                                    },
                                    "filterDefectedFrames": {
                                        "type": "bool",
                                        "defaultValue": false
                                    },
                                    "includeSpeechTranscript": {
                                        "type": "bool",
                                        "defaultValue": true
                                    },
                                    "documentIntelligenceAPI": {
                                        "type": "string",
                                        "defaultValue": "[parameters('documentIntelligenceEndpoint')]"
                                    },
                                    "gpt4_deployment_name": {
                                        "type": "string",
                                        "defaultValue": "[parameters('gpt4DeploymentName')]"
                                    },
                                    "openAIAPI": {
                                        "type": "string",
                                        "defaultValue": "[parameters('azureOpenAiEndpoint')]"
                                    },
                                    "embeddingDeploymentName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('embeddingsDeploymentName')]"
                                    },
                                    "searchServiceEndpoint": {
                                        "type": "string",
                                        "defaultValue": "[parameters('aiSearchServiceEndpoint')]"
                                    },
                                    "aiSearchIndexName": {
                                        "type": "string",
                                        "defaultValue": "[parameters('indexName')]"
                                    },
                                    "storageAccountResourceId": {
                                        "type": "string",
                                        "defaultValue": "[parameters('storageAccountResourceId')]"
                                    },
                                    "modelId": {
                                        "type": "string",
                                        "defaultValue": "[parameters('documentIntelligenceModelId')]"
                                    }
                                },
                                "variables": {
                                    "top_p": {
                                        "type": "String"
                                    },
                                    "temperature": {
                                        "type": "String"
                                    },
                                    "resultID": {
                                        "type": "String"
                                    }
                                },
                                "annotations": [],
                                "lastPublishTime": "2024-03-14T09:21:15Z"
                            }
                        }
                    ]
                }
            }
        }
    ],
    "outputs": {
        "cosmosDbNoSqlPrivateEndpointRequest": {
            "type": "string",
            "value": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), last(split(reference(parameters('cosmosDbNoSqlResourceId'), '2023-11-15', 'Full').properties.privateEndpointConnections[0].id, '/')), 'na')]"
        },
        "storagePrivateEndpointRequest": {
            "type": "string",
            "value": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), reference(parameters('storageAccountResourceId'), '2023-01-01', 'Full').properties.privateEndpointConnections[0].name, 'na')]"
        },
        "aiSearchPrivateEndpointRequest": {
            "type": "string",
            "value": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), reference(parameters('aiSearchResourceId'), '2022-09-01', 'Full').properties.privateEndpointConnections[0].name, 'na')]"
        },
        "docIntelPrivateEndpointRequest": {
            "type": "string",
            "value": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), last(split(reference(parameters('documentIntelligenceResourceId'), '2022-03-01', 'Full').properties.privateEndpointConnections[0].name, '/')), 'na')]"
        },
        "azureOpenAiPrivateEndpointRequest": {
            "type": "string",
            "value": "[if(equals(parameters('dfDisableNetworkAccess'), 'Yes'), last(split(reference(parameters('azureOpenAiResourceId'), '2022-03-01', 'Full').properties.privateEndpointConnections[0].name, '/')), 'na')]"
        }
    }
}
]
  JSON
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_data_factory" {
  resource_id = azurerm_data_factory.data_factory.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_data_factory" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_data_factory.data_factory.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}