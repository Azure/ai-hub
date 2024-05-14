# Enterprise Azure OpenAI Hub - Terraform setup

## Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
- [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed

## Git Setup

```
git config --global submodule.recurse true

git submodule update --init --recursive

git clone  https://github.com/Azure/ai-hub.git
```

## Local Setup

Make sure you replace:

-  _azureregion_ with your desired Azure region (for example, swedencentral)
- _xx-XX_ with the default language of the content to be processed (for example, en-US or es-ES)
- _yourprefix_ with your desired 8-character prefix. 

```
az login

cd .\infrastructure\terraform\
# For Linux use 'cd infrastructure/terraform/'

terraform init

terraform plan -var="location=azureregion" -var="environment=dev" -var="default_language=xx-XX" -var="prefix=yourprefix" 

terraform apply -var="location=azureregion" -var="environment=dev" -var="default_language=xx-XX" -var="prefix=yourprefix"
```

## Remote Setup

TBD

## Redeployment

If you make changes in your local clone, run the following command to redeploy and make the corresponding updates in your Azure environment:

```
terraform apply -var="location=azureregion" -var="environment=dev" -var="default_language=xx-XX" -var="prefix=yourprefix"
```

## For YOLO

```
terraform apply -auto-approve -var="location=azureregion" -var="environment=dev" -var="default_language=xx-XX" -var="prefix=yourprefix"
```
