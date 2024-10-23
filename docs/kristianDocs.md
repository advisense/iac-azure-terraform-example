#### Create application and assign permissions
az ad app create --display-name "kristianGithubActionsContributor"
** Take note of the application (client) ID **
#### create a service principle for your application, and assign desired roles to it
az ad sp create --id <APPLICATION_ID>
az role assignment create --assignee "<APPLICATION_ID>" --role "Contributor" --scope "/subscriptions/$ARM_SUBSCRIPTION_ID"
az role assignment create --assignee <APPLICATION_ID>  --role "Reader and Data Access" --scope "/subscriptions/$ARM_SUBSCRIPTION_ID"

#### create federated credentials to allow github to use the service principal
issuer: https://token.actions.githubusercontent.com
subject: repo:advisense/iac-azure-terraform-example:environment:production

credentials.json

{
	"name": "kristianGithubActionsContributorFedCred"
	"issuer": "https://token.actions.githubusercontent.com"
	"subject": "repo:advisense/iac-azure-terraform-example:environment:production"
	"description": "federated credentials for read/write via GitHub actions"
	"audiences": [
                "api://AzureADTokenExchange"
        ]
}

az ad app federated-credential create --id <APPLICATION_ID> --parameters credentials.json
