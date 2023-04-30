# Resource to create a VM
resource "proxmox_vm_qemu" "server" {

  # Node info
  target_node = "pve" # Run 'hostname' on proxmox cli

  # VM Template to clone
  clone = "ubuntu-server"

  # VM info
  name      = "ubuntu2"             # A unique name for the new vm
  desc      = "ubuntu test machine" # Description for the host machine
  cores     = 2                     # Default, Run 'lscpu | grep "^CPU(s):"' to view how many CPUs in total 
  sockets   = 1                     # Default, Keep with '1' unless you have more than one CPU installed and want to utilize both 
  cpu       = "host"                # Default, only change if needed for architectural purposes
  memory    = 4096                  # Amount of memory to allocate
  ipconfig0 = "ip=dhcp"             # Use DHCP to assign an IP
}
