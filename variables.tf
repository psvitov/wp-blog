## variables.tf

variable "yc_token" {
    description = "ID Yandex.Token"
    default = "<OAuth key>"
    sensitive = true
}

variable "yc_cloud_id" {
    description = "ID Yandex.Cloud"
    default = "<ID Yandex.Cloud>"
    sensitive = true
}

variable "yc_region_a" {
    description = "Region Zone A"
    default = "ru-central1-a"
}

variable "yc_region_b" {
    description = "Region Zone B"
    default = "ru-central1-b"
}

variable "yc_region_c" {
    description = "Region Zone C"
    default = "ru-central1-c"
}
