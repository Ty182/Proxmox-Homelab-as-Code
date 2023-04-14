# Resource to create a VM
resource "proxmox_vm_qemu" "server" {

  # Node info
  target_node = "pve" # Run 'hostname' on proxmox cli

  # VM info
  name    = "ubuntu"                                     # A name for the new vm
  desc    = "ubuntu test machine"                        # Description for the host machine
  iso     = "local:iso/ubuntu-22.04.2-desktop-amd64.iso" # <storage name>:iso/<iso name> | Datacenter > node name > local > ISO Images
  cores   = 2                                            # Default, Run 'lscpu | grep "^CPU(s):"' to view how many CPUs in total 
  sockets = 1                                            # Default, Keep with '1' unless you have more than one CPU installed and want to utilize both 
  cpu     = "host"                                       # Default, only change if needed for architectural purposes
  memory  = 4096                                         # Amount of memory to allocate
}
