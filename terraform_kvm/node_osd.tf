# variable "node_osd_nombre" {
#   default = "${var.nombre}-osd"
#   type = string
# }

module "node_osd_cloud_init" {
  count = var.node_osd_count

  # source = "/home/repo/tf_modules/cloud_init"
  source = "git::https://github.com/maxrinal/tf_modules.git//cloud_init"

  nombre = "${var.nombre}-osd-n0${count.index}"
  # nombre = "${node_osd_nombre}-n0${count.index}"

  search_domain         = "ingress.lab.home"
  user_name             = var.user_name
  user_default_password = var.user_pass

}


module "node_osd" {
  # source = "/home/repo/tf_modules/kvm_complex_instance"
  source = "git::https://github.com/maxrinal/tf_modules.git//kvm_complex_instance"

  depends_on = [
    module.node_osd_cloud_init
  ]

  # -- # Para crear multiples instancias
  count  = var.node_osd_count
  nombre = "${var.nombre}-osd-n0${count.index}"
  # nombre = "${node_osd_nombre}-n0${count.index}"

  cloud_init_data = module.node_osd_cloud_init[count.index].out_rendered

  assigned_cpu       = var.node_osd_cpu
  assigned_memory_mb = var.node_osd_memory_mb

  network_name_list       = var.node_osd_network
  network_wait_dhcp_lease = true


  os_base_path    = var.node_osd_os_path
  os_disk_size_mb = var.node_osd_disk_size
  disk_list       = var.node_osd_extra_disk
  # disk_list             = { "docker" : 1024, "data" : 512 }
  # disk_list             = { "disk_01" : 5, "disk_02" : 5, "disk_03" : 5, "disk_04" : 5 }
}

