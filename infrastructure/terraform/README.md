# Enterprise Azure OpenAI Hub - Terraform setup

## Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
- [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed

## Git Setup

```
git config --global submodule.recurse true

git clone  https://github.com/Azure/ai-hub.git

git submodule update --init --recursive
```

## Local Setup

Make sure you replace:

-  {your-azure-region} with your desired Azure region (for example: switzerlandnorth)
- {xx-XX} with the default language of the content to be processed (for example: en-US or es-ES)
- {yourprefix} with your desired prefix (must be less than 8 characters). 

```
az login

cd .\infrastructure\terraform\
# For Linux use 'cd infrastructure/terraform/'

terraform init

terraform plan -var="location={your-azure-region}" -var="environment=dev" -var="default_language={xx-XX}" -var="prefix={yourprefix}" 

terraform apply -var="location={yourazureregion}" -var="environment=dev" -var="default_language={xx-XX}" -var="prefix={yourprefix}"
```

As an example, if your desired Azure region is _swedencentral_, the content language is _es-ES_ and your desired prefix is _mmai515_, the command lines should look like:

```
terraform init

terraform plan -var="location=swedencentral" -var="environment=dev" -var="default_language=es-ES" -var="prefix=mmai515" 

terraform apply -var="location=swedencentral" -var="environment=dev" -var="default_language=es-ES" -var="prefix=mmai515"
```



## Remote Setup

TBD

## Redeployment

If you make changes in your local clone, run the following command to redeploy and make the corresponding updates in your Azure environment:

```
terraform apply -var="location={yourazureregion}" -var="environment=dev" -var="default_language={xx-XX}" -var="prefix={yourprefix}"
```

## For YOLO

```
terraform apply -auto-approve -var="location={yourazureregion}" -var="environment=dev" -var="default_language={xx-XX}" -var="prefix={yourprefix}"
```
