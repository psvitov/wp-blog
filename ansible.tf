resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 120"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "wordpress" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./ansible/inventory.ini wp-blog.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "monitoring" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./ansible/inventory.ini monitoring.yml"
  }

  depends_on = [
    null_resource.wordpress
  ]
}
