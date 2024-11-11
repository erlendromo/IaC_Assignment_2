# Second Compulsory Assignment

Your company, OperaTerra, is launching a new e-commerce platform. As a DevOps engineer, you're tasked with setting up the infrastructure on Microsoft Azure using Terraform. The platform requires a web application, a database for product information and user data, and a storage solution for product images.

## Requirements

The infrastructure components you need to set up include a Virtual Network with proper subnets, an Azure Service Plan for hosting the web application, an SQL Database for storing product and user data, Azure Blob Storage for storing product images, and an Load Balancer in front of the web application.
You are required to implement this infrastructure for three environments: Development (dev), Staging, and Production (prod).
Your Terraform implementation should define and deploy all infrastructure components. You should create modules for reusable components such as networking, app service, database, and storage. Use locals for environment-specific customization and implement random name generation for globally unique resource names. Ensure that you pass information between root module and child modules effectively. Additionally, use remote state storage with Azure Storage Account.
The main focus for this assignment is to implement a CI/CD pipeline using GitHub Actions or simular available tools (Digger etc.).
For infrastructure configuration it should be created branches (remember good naming convention and life cycle) that should undergo code reviews (terraform fmt, terraform validate and tflint/tfsec) before they are merged into the environment branches (e.g., dev, staging, prod), which providing a layer of quality assurance.
Create Pull Request to perform merging with environment branches.
Merging with environment branches should trigger a workflow that will plan and apply infrastructure to workspaces except prod
For deoployment of infrastructure in prod it must be aproved by a minimum of one person.
 
An important part of this assignment is to analyze and discuss the three provided folder structure alternatives. You should choose one and justify your decision based on scalability, maintainability, separation of concerns, and ease of implementing CI/CD.

## Deliverables

IMPORTANT! A .zip-file with the following name, files and folders: Name the zip file with the ntnu username and oppg2, such as: melling-oppg2.zip In the zip file there must be a folder with the same name as the zip file: ntnuusername-oppg2, such as: melling-oppg2. The folder naturally contains the terraform files and folders and the CI/CD pipeline configuration files. A README.md file explaining your solution and how to use it. The reason for the naming is to streamline censorship and display in VS Code.
Additionally, prepare a brief report (maximum 2 pages) discussing your chosen folder structure and your justification for it. In this report, also describe the challenges you faced during the implementation and how you overcame them. Finally, suggest potential improvements or optimizations for your solution.
NOTE! It should be written so flexible that learning assistant or teacher could deploy this resources based on small changes, like change subscription ID.

## Evaluation Criteria

Your submission will be evaluated based on the correct implementation of required infrastructure components and proper use of Terraform best practices, including effective use of modules, locals, variables, and outputs. We will also assess your effective use of Azure resources, the quality and clarity of your code and documentation, your thoughtful analysis of folder structure options, and the successful implementation of the CI/CD pipeline.
This assignment is designed to test your ability to apply Terraform and Azure knowledge in a realistic scenario, make informed decisions about code organization, and implement robust DevOps practices. Good luck with your implementation!