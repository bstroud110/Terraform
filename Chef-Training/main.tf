# Configure the Libvirt provider
provider "libvirt" {
  uri = "qemu:///system"
}


variable "vm_name" {
  type = map(map(string))
  default = {
    chef-client-1 = {
      name    = "chef-client-1"
      machine = "q35"
    }
    chef-client-2 = {
      name    = "chef-client-2"
      machine = "q35"
    }
    chef-client-3 = {
      name    = "chef-client-3"
      machine = "q35"
    }
  }
}

resource "libvirt_domain" "vms" {
  for_each   = var.vm_name
  name       = each.value.name
  memory     = "2048"
  running    = false
  autostart  = true
  machine    = each.value.machine
  qemu_agent = true
}
