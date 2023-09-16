### Majority of the text is generated with Chatgpt

```
This script has deployment script for Streamlit to azure with Azure Ad login

```

## About Streamlit app









## About terraform

Terraform state files are stored in blob, so before create storage account and container for you terraform.

This terraform is used to deploy Streamlit app to azure webapp. There are two resource needed for that:

#### Azure Service Plan:

Purpose: The service plan defines the characteristics of the hosting environment for the Azure Web App.
Configuration: The azurerm_service_plan resource in main.tf specifies the settings for the service plan.

#### Azure Linux Web App:

Purpose: This is the Azure Web App running on Linux where your application code is hosted.
Configuration: The azurerm_linux_web_app resource in main.tf specifies the settings for the web app.

For running the app, there is the Streamlit run command for running the app. 

**NB!** If you have a different folder structure then you might need to configure it

For example the app is in a app/ folder then the run command should also have .app/ folder 


```

  site_config {
    app_command_line = "python -m streamlit run app.py  --server.port 8000 --server.address 0.0.0.0"

    application_stack {
      python_version = "3.10"
    }
  }

```

### App registration for you sign in client id

Considering that creating a app registration usually requires administration rights, especially when creating a sign in app, app is create manually from the azure portal. 

1. Option

* I suggest to deploy the app without `CLIENT_ID_AD` and replace it with `---`, so that it is not empty.
* Then when the app I deployed, go the Azure portal, the app you deployed, under settings/Authentication add identity provider select Microsoft and then create new enterprise application.
[Authenticate and authorize users end-to-end in Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/tutorial-auth-aad?pivots=platform-linux)

2. Option

Separated terraform resource: 

[Resource: azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application)


3. Option

Create it with azure Cli

[az ad app create](https://learn.microsoft.com/en-us/cli/azure/ad/app?view=azure-cli-latest#az-ad-app-create)






#### SCRIPT DEPLOYMENT:

**Publishing Code to an Azure Web App (Linux)**

This section of the code defines a sequence of actions for publishing code to an Azure Web App running on Linux. These instructions involve creating a local command to perform the deployment and using a null_resource with a local-exec provisioner to execute this command.

**Local Block for Command Definition:**

1. The locals block defines a command for publishing code to the Azure Web App (Linux). It constructs a command string using the Azure CLI (az) to upload a ZIP archive of your application code to the web app. The command uses variables and attributes to dynamically build the command string.

    * `publish_code_command_linux:` This variable holds the command string. It uses Terraform's string interpolation to include the Azure resource group and web app names, as well as the path to the ZIP archive (var.archive_file_streamlit).

2. Variable for Archive File Path:

    The `variable` block defines a Terraform variable named `archive_file_streamlit`. This variable specifies the path to the ZIP archive containing your application code. You can customize this path if your code is located elsewhere.

    * `type:` Specifies that the variable is of type `string`.

      `default:` Provides a default value, which is the path to the ZIP archive located in the `./streamlit directory`.


3. Data Block for Creating ZIP Archive:

    The `data` block creates a ZIP archive from the specified source directory (`./streamlit`) and stores it in the path specified by `var.archive_file_streamlit.` This archived code will later be used for deployment to the Azure Web App.

4. Null Resource for Code Deployment:

    The resource block defines a null_resource named "app" for deploying the code to the Azure Web App. The local-exec provisioner is used to execute a command locally.

    * `provisioner` `"local-exec"`: Specifies the use of the `local-exec` provisioner.

    * `command:` Sets the command to be executed, which is the value defined in the publish_code_command_linux variable.

    * `depends_on:`  Ensures that this resource depends on the local command being executed successfully.

    * `triggers:` Specifies triggers that can force the execution of this resource, including changes to the input JSON file and the publish code command.


By following these instructions, Terraform will use the defined command to upload the ZIP archive of your code to the Azure Web App when you apply the configuration changes. This process ensures that your application is deployed to the web app on Azure.

**NB!** if you run this locally it will generate zip file as well, you don't want the zip file in your github and deploy it with the deployment file

You can add the zip into .gitignore like this

```
 echo "*.zip" >> .gitignore

```

## About the deployement  .github/workflows/terraform.yml


#### Trigger
The workflow is triggered when a push event occurs on the dev branch and when changes are made to files in the .github/workflows/terraform.yml path or the terraform/ directory.
#### Jobs
The workflow defines a single job named terraform.
Environment Variables and Secrets
The job sets several environment variables to securely store sensitive information like Azure credentials and Terraform variables. These values are populated using GitHub Secrets.
Defaults
The job sets some defaults for its runs, specifying the shell as bash and setting the working directory to ./terraform.
Workflow Steps
Checkout: This step checks out the code from the repository using the actions/checkout@v2 action.

`Setup Terraform:` It sets up Terraform by installing the specified Terraform version using the hashicorp/setup-terraform@v2 action.

`Log in with Azure:` This step logs in to Azure using the Azure CLI and the provided Azure credentials stored in the secrets.AZURE_CREDENTIALS secret.

`Terraform Init:` Initializes the Terraform configuration in the ./terraform directory. It passes several Terraform variables and secrets as -var flags, including key, ARM_TENANT_ID, RESOURCE_GROUP_NAME, STORAGE_ACCOUNT_NAME, and CLIENT_ID_AD.

`Terraform Plan:` This step generates an execution plan for Terraform, showing the changes that will be applied to the Azure infrastructure. It also uses various -var flags to pass Terraform variables.

`Terraform Apply:` Finally, this step applies the Terraform execution plan to create or update Azure resources. It uses the -auto-approve flag to automatically approve the changes without manual confirmation. It also passes Terraform variables.

**Configuration and Secrets**

This workflow relies on the following environment variables and GitHub Secrets, which should be configured in your GitHub repository settings:

`secrets.AZURE_CLIENT_ID:` Azure Active Directory (AD) application client ID.

`secrets.ARM_CLIENT_SECRET:` Azure AD application client secret.

`secrets.ARM_SUBSCRIPTION_ID:` Azure subscription ID.

`secrets.ARM_TENANT_ID:` Azure AD tenant ID.

`secrets.RESOURCE_GROUP_NAME:` Azure resource group name.

`secrets.STORAGE_BLOB_NAME:` Name of the Azure Storage Blob.

`secrets.STORAGE_ACCOUNT_NAME:` Name of the Azure Storage Account.

`secrets.CLIENT_ID_AD:` Client ID for Azure AD application, this is for the Azure active directory login.

`secrets.key:` Storage account key.

`secrets.AZURE_CREDENTIALS:` Azure credentials, json format for logging in to Azure.

```
az ad sp create-for-rbac --name <nameOftheServiceprincipal> \
                         --role contributor \
                         --scopes /subscriptions/<targetsubscription>/resourceGroups/<resourcegroupname> \
                         --json-auth -- this is for getting the right format

```
Ensure that these secrets are properly set in your GitHub repository to enable the workflow to authenticate and deploy to Azure securely.

#### Customizing the Workflow

To customize this workflow for your specific Terraform project or Azure deployment, you may need to modify the following:

The paths for triggering the workflow (on.push.branches and on.push.paths) to match your repository structure.

The Terraform variables passed in the terraform init, terraform plan, and terraform apply steps to align with your infrastructure definition.

Additional steps or actions for setting up any specific requirements for your project.
Please refer to the Terraform documentation and Azure documentation for more details on how to configure Terraform for your specific use case and to obtain the necessary Azure credentials and configurations.

#### Conclusion

This GitHub Actions workflow simplifies the deployment of infrastructure to Azure using Terraform in a secure and automated manner. It can be easily customized to fit your project's requirements by adjusting the workflow triggers, Terraform configurations, and secrets according to your needs.


This code is for demo, developer takes no responsibilities.