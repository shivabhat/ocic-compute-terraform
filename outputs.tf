output "instance_ids" {
  value = ["${opc_compute_instance.linux_instance.*.name}"]
}
/*
output "public_ip" {
  value = ["${oci_core_instance.linux_instance.*.public_ip}"]
}
*/
output "private_ip" {
  value = ["${opc_compute_instance.linux_instance.*.ip_address}"]
}

output "display_name" {
  value = ["${opc_compute_instance.linux_instance.*.name}"]
}

output "dns" {

  #value = "fa-pod-manager-${opc_compute_instance.linux_instance.*.count}-${var.env}-${var.aditional_custom_prefix}-${var.instance_display_name}.${var.instance_domain_name}"
  value = ["${formatlist("%s.%s", opc_compute_instance.linux_instance.*.hostname, var.instance_domain_name)}",]
  #value = ["${lookup(opc_compute_instance.linux_instance.*.networking_info[0], "dns")}"]
  #value = ["${opc_compute_instance.linux_instance.*.fqdn}"]

}

output "instances_ids" {
  value = ["${formatlist("/Compute-%s/%s/%s", var.identity_domain, var.user, opc_compute_instance.linux_instance.*.name)}",]
}
/*
output "availability_domain" {
  value = ["${oci_core_instance.linux_instance.*.availability_domain}"]
}
*/
