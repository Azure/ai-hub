# Enterprise Azure OpenAI Hub - Terraform setup

## Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
- [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed

## Setup

```
git config --global submodule.recurse true

git clone  https://github.com/Azure/ai-hub.git
```

## Local Setup

```
az login

terraform plan -var="location=swedencentral" -var="environment=dev" -var="prefix=mmai-tf-1"

terraform apply -var="location=swedencentral" -var="environment=dev" -var="prefix=mmai-tf-1"
```

## For Remote Setup

TBD

## For YOLO

```
terraform apply -auto-approve -var="location=swedencentral" -var="environment=dev" -var="prefix=mmai-tf-1"
```
