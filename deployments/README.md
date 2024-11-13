# OperaTerra

This is the entrypoint for deploying the OperaTerra infrastructure. Using modules, this configuration provisions a VNET with DNS, subnet(s), NSG and NSR(s) for networking. Alongside this a Storage Account with a container is created. Since the name of a storage-account needs to be unique, the resource `random_string` is used for this purpose. This creates the base of the infrastructure, as both the database and app-service modules needs networking and storage for its configuration.

## Project Structure Selection

The project structure options all have their pros and cons, but for OperaTerra, simplicity and control is more important than strict governance over environments and access control. As OperaTerra is a new (and small) E-commerce platform, project structure alternative two is suitable. As an initial thought, i went for alternative three, as i wanted a balance between simplicity and maintainability. After a couple weeks went by coding the infrastructure, i saw fit to migrate to alternative two as the project wasn't big enough (in my opinion) for sacrificing maintainability. Environment separation was already implemented using terraform workspace and locals for customization, so the final decision of migrating was a welcoming one as i am the only engineer working on the project.

## Actions & Workflows

This project uses GitHub Actions for the basic terraform commands:

- `terraform init`
- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- `terraform destroy`

...as well as these extentions for terraform security:

- `tfsec`
- `checkov`

...and these for the go web-app deployment:

- `go build`
- `go run`

This provides ease-of-use as the developer (me) only needs to write code, push to branch, and merge pull-requests. The actions/workflows automatically formats, validates, checks security, plans, and applies/deploys the code.
Alongside the actions, the GitHub repository is setup with Environments (dev, stage, prod) to ensure manual review of the infrastructure to be deployed. These are relatively simple tasks employed to ensure quality-control of the code.

### Actions by third-party

- GitHub `actions/checkout`
- GitHub `actions/cache`
- DFLook `dflook/terraform-fmt`
- GitHub `actions/setup-go`
- Azure `azure/login`
- Azure `azure/webapps-deploy`
- AquaSecurity `aquasecurity/tfsec-action`
- BridgeCrewIO `bridgecrewio/checkov-action`
