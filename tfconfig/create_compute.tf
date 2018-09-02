#Create linux instances
resource "opc_compute_instance" "linux_instance" {
  count      = "${var.no_of_nodes}"
  name       = "${var.instance_display_name}_${count.index}"
  label      = "${var.instance_display_name}_${count.index}"
  shape      = "${var.shape}"
  image_list = "${var.instance_image["image_list"]}"
  ssh_keys = ["${var.ssh_public_key}"]
  hostname = "${lower("${var.instance_display_name}_${count.index}")}"
  storage {
    volume= "${element(opc_compute_storage_volume.compute-boot-volume.*.name, count.index)}"
    index  = 1
  }
  networking_info {
    index          = 0
    shared_network = false
    ip_network = "${opc_compute_ip_network.scompute-ip-network.name}"
    dns = ["${lower("${var.instance_domain_name}_${count.index}")}"]
    vnic =  "/Compute-${var.identity_domain}/${var.user}/${var.instance_display_name}_${count.index}_eth0"
    vnic_sets = ["${opc_compute_vnic_set.scompute-vnic-set.name}"]
  }
}
/*
resource "null_resource" "configure-docker" {
  count      = "${var.no_of_nodes}"
  provisioner "remote-exec" {
    connection = {
      timeout      = "5m"
      host= "${element(opc_compute_instance.linux_instance.*.ip_address, count.index)}"
      private_key = "${var.ssh_private_key}"
      user         = "opc"
      agent        = false
    }
    inline = [
      "sudo -s bash -c 'mkfs.ext4 -F /dev/xvdc'",
      "sudo -s bash -c 'mkdir -p ${var.volume_mount_directory}'",
      "sudo -s bash -c 'mount -t ext4 /dev/xvdc ${var.volume_mount_directory} '",
      "echo '/dev/xvdc  ${var.volume_mount_directory} ext4 defaults,noatime,_netdev,nofail    0   2' | sudo tee --append /etc/fstab > /dev/null",
    ]
  }
}
*/
#storage boot volume
resource "opc_compute_storage_volume" "compute-boot-volume" {
  count      = "${var.no_of_nodes}"
  name             = "${var.instance_display_name}_${count.index}_boot_volume"
  description      = "${var.instance_display_name}_${count.index}_boot_volume"
  size             = 14
  tags             = ["swarm_compute"]
  bootable         = true
  image_list       = "${var.instance_image["image_list"]}"
  image_list_entry = "${var.instance_image["version"]}"
}

# Create an Public IP Reservation
resource "opc_compute_ip_address_reservation" "public_nat_ip" {
  name            = "${var.instance_display_name}_${count.index}_Public_NAT_IP"
  ip_address_pool = "public-ippool"
  description = "Public_NAT_IP"
  tags = ["swarm_compute"]
  count      = "${var.no_of_nodes}"
}

/*
resource "null_resource" "install_docker" {
  count      = "${var.no_of_nodes}"
  provisioner "file" {
       connection {
              user = "opc"
              agent = false
              private_key = "${var.ssh_private_key}"
              timeout = "10m"
              host = "${opc_compute_instance.public_ip[count.index]}"
       }
       source      = "docker_install.sh"
       destination = "/tmp/docker_install.sh"
  }

  provisioner "remote-exec" {
        connection {
          user = "opc"
          agent = false
          private_key = "${var.ssh_private_key}"
          timeout = "10m"
          host = "${opc_compute_instance.public_ip[count.index]}"
         }
         inline = [
           "chmod uga+x /tmp/docker_install.sh",
           "sudo su - root -c \"/tmp/docker_install.sh true ${var.http_proxy} ${var.https_proxy}\"",
            ]
  }

}

*/

