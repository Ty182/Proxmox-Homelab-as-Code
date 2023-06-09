# This is all defined by proxmox provider documentation
terraform {

  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  # This references env vars 
  pm_api_url          = var.proxmox_api_url          # export TF_VAR_proxmox_api_url="https://<proxmoxIP>:<proxmoxPort/api2/json"
  pm_api_token_id     = var.proxmox_api_token_id     # export TF_VAR_proxmox_api_token_id="<proxmoxUser>@<proxmoxNode>\!<proxmoxApiToken>"
  pm_api_token_secret = var.proxmox_api_token_secret # export TF_VAR_proxmox_api_token_secret="<proxmoxApiTokenSecret>"
}
