# Description 
Everything here is used to create a Proxmox VM template using Packer. 

- ```files/99-pve.cfg```
    - This is used for cloud-init
- ```http/```
    - Packer deploys a local http server and serves up the files found in here.
    - ```/meta-data``` leave this file blank since we're using Proxmox and not a cloud image.
    - ```/user-data``` this is the configuration file used by cloud-init.
- ```ubuntu-server.pkr.hcl```
    - This is the Packer file that configures the VM template in Proxmox.
    - In this file you'll notice three variables created at the top that reference environment variables. 
    - To create these environment variables you can run this from your terminal:
        - ```export PROXMOX_URL="https://<proxmoxIP>:<proxmoxPort>/api2/json"```
        - ```export PROXMOX_USERNAME="<proxmoxUser>@<proxmoxNode>\!<proxmoxApiToken>``` (Don't forget the ```\``` in front of the ```!```)
        - ```export PROXMOX_TOKEN="<proxmoxApiTokenSecret>"```
    - **Note - it is not best practice to store secrets in environment variables on your local system. I plan to utilize CI/CD in the future.**

### Helpful Packer Commands
- [Packer documentation](https://developer.hashicorp.com/packer/docs)
- These commands should be run in the same directory as the ```ubuntu-server.pkr.hcl``` file
    - ```packer init .``` Downloads Packer plugins needed
    - ```packer fmt .``` Formats your file correctly e.g., fixes spacing, etc.
    - ```packer validate .``` Verifies the syntax is correct
    - ```packer build .``` Runs the packer file i.e., deploys vm template to Proxmox