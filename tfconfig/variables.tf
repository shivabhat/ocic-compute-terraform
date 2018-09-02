variable "user" {}
variable "password" {}
variable "identity_domain" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "region" {}
variable "compute_rest_endpoint" {}
variable "no_of_nodes" {}
variable "instance_display_name" {}
variable "instance_domain_name" {}
variable "instance_hostname_label" {}

variable "shape" {
  default = "oc3"
}

variable "instance_image"{
  type = "map"
  default = {
    "image_list" = "/oracle/public/OL_7.2_UEKR4_x86_64"
    "version" = "1"
  }
}
#variable "image_id" {}
#variable "image_id_version" {}



variable "skip_source_dest_check" {
  default = false
}
variable "assign_public_ip" {
  default = "false"
}

variable "volume_mount_directory" {
  default = ""
}
variable "volume_size_in_gbs" {
  default = "50"
}


variable "user_data_file" {
  default = ""
}



