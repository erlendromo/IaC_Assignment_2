# Second Compulsory Assignment

Your company, OperaTerra, is launching a new e-commerce platform. As a DevOps engineer, you're tasked with setting up the infrastructure on Microsoft Azure using Terraform. The platform requires a web application, a database for product information and user data, and a storage solution for product images.

## How To Use

### GitHub Environments

Although only `Production` environment is needed per the assignment requirements, this project uses environments for all the protected brances to add another layer of quality assurance for the terraform infrastructure:

- `Development` (branch: dev)
- `Stage` (branch: stage)
- `Production` (branch: main) 

### GitHub Secrets

Some GitHub Secrets needs to be added to the repository for a successful deployment of the infrastructure:

Azure Service Principal:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

Terraform Variables:
- `MSSQL_ADMINISTRATOR_LOGIN` -> The username used for the sql database
- `MSSQL_ADMINISTRATOR_LOGIN_PASSWORD` -> The password used for the sql database

### Setup Terraform Workspaces

Make sure to run the following commands locally when the backend is first deployed:

```code
cd deployments
terraform init
terraform workspace new dev
terraform workspace new stage
terraform workspace new prod
```

This ensures no errors occur when running the workflows for deploying later on.

### Backend

If the use of the backend is wanted, in the `terraform.tf` file in the directory `backend` needs to be managed manually at first.

Deploy the backend locally (comment out the backend code in `terraform.tf`) with the following commands:
```code
cd backend
terraform init
terraform apply
```

Deploy the backend remotely (comment out the backend code in `terraform.tf`):
Push the code to a repository, and run the workflow named `Deploy Backend` manually (`deploy_backend.yaml`)


After the backend is deployed, doublecheck that the `backend` block in the `deployments/terraform.tf` file is correctly addressing the proper backend configuration.

### Usage

When pushing code to a remote branch that is NOT `dev`, `stage`, or `main`, a workflow (feature.yaml) is run to format and validate the terraform configuration. When merging a pull-request to any of the protected brances, workflows run for validating, planning, applying and deployment of the terraform infrastructure as well as a sample go-web-api. This is done using terraform workspaces to separate the different environments. 

When all this is in order, simply push code to a `feature`-branch, create pull-requests to the protected branches, and merge changes all the way to the `main(production)`-branch, and wait for the terraform infrastructure to be deployed.