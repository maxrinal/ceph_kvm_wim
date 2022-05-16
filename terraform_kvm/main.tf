### - ##Creacion de inventario para ansible
resource "local_file" "inventory_ansible" {
  depends_on = [
    module.node_mon,
    module.node_osd,
  ]
  content = templatefile("../templates/inventory.tmpl",
    {
      hosts_user         = var.user_name
      node_mon_list      = module.node_mon.*.clean_out
      node_osd_list      = module.node_osd.*.clean_out
      tf_workspace       = terraform.workspace
      ansible_extra_vars = var.ansible_extra_vars
    }
  )
  filename = "../tmp/${terraform.workspace}/hosts.yml"
}

### - ##Creacion de inventario para ceph orch
resource "local_file" "inventory_ceph_orch" {
  depends_on = [
    module.node_mon,
    module.node_osd,
  ]
  content = templatefile("../templates/inventory_ceph_orch.tmpl",
    {
      hosts_user         = var.user_name
      node_mon_list      = module.node_mon.*.clean_out
      node_osd_list      = module.node_osd.*.clean_out
      tf_workspace       = terraform.workspace
      ansible_extra_vars = var.ansible_extra_vars
    }
  )
  filename = "../tmp/${terraform.workspace}/hosts_ceph_orch.yml"
}



resource "null_resource" "execute_ansible" {
  # Si EXECUTE_ANSIBLE es true debemos ejecutar el bloque de codigo sino no(count=0)
  count  = (var.EXECUTE_ANSIBLE == true ? 1:0)
  depends_on = [
    module.node_mon,
    module.node_osd,
    resource.local_file.inventory_ansible,
    resource.local_file.inventory_ceph_orch
  ]
  triggers = {
    mon_count = "${var.node_mon_count}" 
    osd_count = "${var.node_osd_count}" 
    osd_disk_count = length(var.node_osd_extra_disk)
  }
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ../ansible/site.yml -i ../tmp/${terraform.workspace}/hosts.yml -u vmadmin"
  }
}



output "ssh_conn" {
  value = <<EOT

# Para conectarse al mon_0
ssh -o StrictHostKeyChecking=no vmadmin@${module.node_mon[0].ipv4_addressess[0]}

# Para tener una consola interactiva con ceph-common instalado
sudo cephadm shell

# Para acceder al dashboard
https://${module.node_mon[0].ipv4_addressess[0]}:8443

EOT

}





output "host_ips" {
  value = module.node_mon.*.clean_out
}

output "entorno_workspace" {
  value = terraform.workspace
}
