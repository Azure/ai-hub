# Enterprise Azure OpenAI Hub - Terraform setup

## Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
- [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed

## Setup

```
git config --global submodule.recurse true

git submodule update --init --recursive

git clone  https://github.com/Azure/ai-hub.git
```

## Local Setup

```
az login

move .\utilities\terraformConfigSamples\* .\infrastructure\terraform\
# For Linux use 'mv utilities/terraformConfigSamples/* infrastructure/terraform/'
# Update prefix in '.\infrastructure\terraform\vars.tfvars'

cd .\infrastructure\terraform\
# For Linux use 'cd infrastructure/terraform/'

terraform init

terraform plan -var="location=swedencentral" -var="environment=dev" -var="default_language=es-ES" -var="prefix=mmai-tf-1" 

terraform apply -var="location=swedencentral" -var="environment=dev" -var="default_language=es-ES" -var="prefix=mmai-tf-1"
```

## For Remote Setup

TBD

## For YOLO

```
terraform apply -auto-approve -var="location=swedencentral" -var="environment=dev" -var="default_language=es-ES" -var="prefix=mmai-tf-1"
```
