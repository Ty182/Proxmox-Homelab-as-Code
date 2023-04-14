# Automated Homelab with Proxmox and Terraform

The aim for this project is to make it super easy to set up and maintain a homelab using code. No more will you need to spend 30 min installing and configuring a VM. The goal will be to automate and build everything as code.

### Setup
I'm using Proxmox as the hypervisor as it's open-source, free to use, and has a community-created Terraform provider. This is installed on an old Intel Nuc I bought years ago for messing around with. 
Specs:
- Intel Core i5-8259U CPU (8 cores)
- 16GB RAM
- 256GB NVME

### Getting Started
- Install [Proxmox](https://www.proxmox.com/en/downloads/category/proxmox-virtual-environment)
- Install Terraform ```brew install terraform```
- Copy the .tf files, customize, and run

### To Do
- [ ] Customize VM image so you dont have to set it up after provisioning
- [ ] Packer ?
- [ ] GitHub Actions integration? 
- [x] Provision initial VM with Terraform

### References
- [Proxmox Terraform Provider](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)