# Description
Everything here is used to create a VM in Proxmox utilizing a VM template stored in Proxmox.

### Helpful Terraform Commands
- [Terraform documentation](https://developer.hashicorp.com/terraform/cli)
- These commands should be run in the same directory as the ```*.tf``` files
    - ```terraform init``` Downloads terraform providers
    - ```terraform fmt``` Formats your file correctly e.g., fixes spacing, etc.
    - ```terraform validate``` Verifies the syntax is correct
    - ```terraform plan``` Provides a preview of what resources will be created
    - ```terraform apply``` Creates the resources