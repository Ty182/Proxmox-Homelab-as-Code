# A template for creating an Ubuntu Server VM in Proxmox

# Variables
variable "proxmox_url" {
  type    = string
  default = env("PROXMOX_URL") # pull from env var
}

variable "proxmox_username" {
  type    = string
  default = env("PROXMOX_USERNAME") # pull from env var
}

variable "proxmox_token" {
  type      = string
  sensitive = true
  default   = env("PROXMOX_TOKEN") # pull from env var
}

# Resource
source "proxmox" "ubuntu-server" {

  # Proxmox Connection Settings
  proxmox_url = var.proxmox_url
  username    = var.proxmox_username
  token       = var.proxmox_token
  # (Optional) Skip TLS Verification, use if you haven't trusted your proxmox cert
  # insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "pve"                       # proxmox node name
  vm_id                = "8001"                      # arbitrary but helps to identify the template
  vm_name              = "ubuntu-server"             # arbitrary, can be changed when you clone from this template later
  template_description = "Ubuntu Server Jammy Image" # arbitrary 

  # VM OS Settings
  # (Option 1) Local ISO File
  iso_file = "local:iso/ubuntu-22.04.2-live-server-amd64.iso" # iso stored on proxmox local drive
  # - or -
  # (Option 2) Download ISO
  //   iso_url = "https://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
  //   iso_checksum = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
  iso_storage_pool = "local" # local unless you have a different storage pool
  unmount_iso      = true

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size         = "20G" # can be changed later when you clone from this template
    format            = "raw"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm"
    type              = "virtio"
  }

  # VM CPU Settings
  cores = "1" # can be changed later when you clone from this template

  # VM Memory Settings
  memory = "2048" # can be changed later when you clone from this template

  # VM Network Settings
  network_adapters {
    model    = "virtio" # can be changed later when you clone from this template
    bridge   = "vmbr0"  # can be changed later when you clone from this template
    firewall = "false"  # can be changed later when you clone from this template
  }

  # VM Cloud-Init Settings
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  # PACKER Boot Commands - this varies by OS
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]
  boot      = "c"
  boot_wait = "5s"

  # PACKER Autoinstall Settings
  http_directory    = "http"    # cloud-init references the code in this directory
  http_bind_address = "0.0.0.0" # used by the boot_command above
  http_port_min     = 8802      # used by the boot_command above
  http_port_max     = 8802      # used by the boot_command above

  # PACKER will ssh into vm to finish remaining tasks after cloud-init is complete
  ssh_username         = "ubuntu" # username to create on vm
  ssh_private_key_file = "/Users/tyler/.ssh/pve_vms" # ssh privatekey to upload to vm

  # Raise the timeout, when installation takes longer
  ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

  name    = "ubuntu-server" # name to give the template
  sources = ["source.proxmox.ubuntu-server"]

  # Allows for shell commands to run
  provisioner "shell" {
    inline = [
      # wait for cloud-init to finish (boot-finished file must exist), else sleep for 1 second 
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",

      # remove any existing SSH host keys 
      "sudo rm /etc/ssh/ssh_host_*",

      # removes the machine-id since we want to generate a new one later on from this template
      "sudo truncate -s 0 /etc/machine-id",

      # removes any packages that were automatically installed as dependencies and are no longer needed
      "sudo apt -y autoremove --purge",

      # removes cached package files from the local package cache
      "sudo apt -y clean",

      # removes package files that can no longer be downloaded
      "sudo apt -y autoclean",

      # cleans up any temporary files created by cloud-init during the initialization process
      "sudo cloud-init clean",

      # removes a file that disables cloud-init network configuration. This is necessary to ensure that cloud-init will configure the network interfaces on the virtual machine.
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",

      # flushes any pending writes to disk to ensure that all changes are committed before the virtual machine is shut down
      "sudo sync"
    ]
  }

  # Copies this file to the vm which specifies which data sources cloud-init should use to configure the vm. 
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Shell command to move the cloud-init config file to a different location on the vm that can be referenced.
  provisioner "shell" {
    inline = [
      "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
    ]
  }

  //   # Run other shell commands
  //   provisioner "shell" {
  //     inline = [
  //       "sudo apt update && sudo apt upgrade"
  //     ]
  //   }
}