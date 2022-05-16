# Global variables
variable "nombre" { default = "ceph01" }

variable "user_name" { default = "vmadmin" }
variable "user_pass" { default = "Test123456" }



# Mon Node variables
variable "node_mon_count" { default = 1 }
variable "node_mon_cpu" { default = 2 }
variable "node_mon_memory_mb" { default = 2048 }
variable "node_mon_os_path" { default = "/home/repo/images/focal-server-cloudimg-amd64-disk-kvm.img" }
variable "node_mon_network" { default = ["default"] }
variable "node_mon_disk_size" { default = 10 * 1024 }
variable "node_mon_extra_disk" { default = {} }


# Mon osd variables
variable "node_osd_count" { default = 1 }
variable "node_osd_cpu" { default = 1 }
variable "node_osd_memory_mb" { default = 2048 }
variable "node_osd_os_path" { default = "/home/repo/images/focal-server-cloudimg-amd64-disk-kvm.img" }
variable "node_osd_network" { default = ["default"] }
variable "node_osd_disk_size" { default = 10 * 1024 }
# variable "node_osd_extra_disk" { default = {} }
variable "node_osd_extra_disk" { default = { "disk_01" : 5, "disk_02" : 5, "disk_03" : 5, "disk_04" : 5 } }



variable "ansible_extra_vars" {
  default = <<EOF
EOF
  type    = string
}

variable "EXECUTE_ANSIBLE" { default=true }
