module "node_mon_cloud_init" {
  count = var.node_mon_count

  source = "/home/repo/tf_modules/cloud_init"

  nombre = "${var.nombre}-mon-n0${count.index}"

  search_domain         = "ingress.lab.home"
  user_name             = var.user_name
  user_default_password = var.user_pass

}


module "node_mon" {
  source = "/home/repo/tf_modules/kvm_complex_instance"

  depends_on = [
    module.node_mon_cloud_init
  ]

  # -- # Para crear multiples instancias
  count  = var.node_mon_count
  nombre = "${var.nombre}-mon-n0${count.index}"

  cloud_init_data = module.node_mon_cloud_init[count.index].out_rendered

  assigned_cpu       = var.node_mon_cpu
  assigned_memory_mb = var.node_mon_memory_mb

  network_name_list       = var.node_mon_network
  network_wait_dhcp_lease = true


  os_base_path    = var.node_mon_os_path
  os_disk_size_mb = var.node_mon_disk_size
  disk_list       = var.node_mon_extra_disk
  # disk_list             = { "docker" : 1024, "data" : 512 }

  # disk_list             = { "disk_01" : 5, "disk_02" : 5, "disk_03" : 5, "disk_04" : 5 }
}

