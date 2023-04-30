# Automated Homelab with Proxmox and Terraform

The aim for this project is to build a homelab using infrastructure as code and automation. Rather than spend 30min configuring unique VMs, we'll be able to deploy and use VMs within minutes.

Another benefit of defining everything as code and using automation is that we can rip and replace these VMs to ensure they're always up-to-date without needing to worry about implementing a patching process. 

### Setup
I'm using Proxmox as the hypervisor as it's open-source, free to use, and has a community-created Terraform provider. This is installed on an old Intel Nuc I bought years ago for messing around with. 
Specs:
- Intel Core i5-8259U CPU (8 cores)
- 16GB RAM
- 256GB NVME

### Prerequisites 
- Install an IDE like Visual Studio Code ```brew install visual-studio-code --cask```
- Install [Proxmox](https://www.proxmox.com/en/downloads/category/proxmox-virtual-environment)
- Install Terraform ```brew install terraform```
- Install Packer ```brew install packer```

### References
- [Proxmox Terraform Provider](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
- [Proxmox Packer Provider](https://developer.hashicorp.com/packer/plugins/builders/proxmox)

### Directory
- ```packer_template/```
    - Contains packer configuration to create a VM template in Proxmox
- ```terraform_vm_deployment```
    - Contains terraform configuration to deploy VMs to Proxmox utilizing the VM template created by Packer


### To Do List
- [ ] Utilizie a CI/CD process such as GitLab's or GitHub Actions
- [x] Utilize Packer to create a VM template in Proxmox
- [x] Utilize Terraform to deploy VMs via the template to Proxmox