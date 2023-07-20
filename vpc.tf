## vpc-stage

resource "yandex_compute_instance" "wp" {

  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "blog-wp"
  hostname = "blog-wp.internal"
  zone = var.yc_region_a

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8loi0gfu0v74tm2qst"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.wp-subnet-a.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
