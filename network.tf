## network.tf

resource "yandex_vpc_network" "wp-net" {
  name = "wp-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "wp-subnet-a" {
  v4_cidr_blocks = ["10.10.1.0/24"]
  zone           = var.yc_region_a
  name           = "wp-a"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.wp-net.id}"
}
