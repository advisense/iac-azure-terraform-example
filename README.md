# iac-azure-terraform-example
Infrastructure as Code example with Terraform setting up Azure resources

 # Quick guide:

## prerequisite
* Terraform:
  * https://www.terraform.io/downloads.html
  * you should be able to run `terraform -help`
* Azure CLI:
  * https://docs.microsoft.com/cli/azure
  * you should be able to run `az login`
 
Check that you have the latest versions before you continue.

## Nice to have
* Github client:
  * https://desktop.github.com
* A source-code editor (IDE)
  * https://code.visualstudio.com/


# USAGE

1. Clone the repo
2. set env variables for your azure env
    * `export ARM_TENANT_ID=<YOUR_AZURE_TENANT_ID>`
    * `export ARM_SUBSCRIPTION_ID=<YOUR_AZURE_SUBSCRIPTION_ID>`
3. Authenticate towards Azure (if you haven't already done this)
    * `az login`
4. Create the file terraform.tfvars
    * `admin_password = <INSERT_YOUR_PWD_HERE>`
5. Initialize Terraform
    * `terraform init`
6. Terraform plan
    * `terraform plan`
7. Create all the resources 
    * (optional, should be done by pushing no code to GitHub and the pipeline deploying)
    * `terraform apply`

## Clean up

Remember to clean up and delete all the resources when the testing is done.

* `terraform destroy`

