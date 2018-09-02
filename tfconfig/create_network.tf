
resource "opc_compute_acl" "scompute-acl" {
  name        = "scompute-acl"
  description = "This is swarmcompute acl"
  tags                = ["swarm_compute"]
}


resource "opc_compute_vnic_set" "scompute-vnic-set" {

  name         = "scompute-vnic-set"
  description  = "swarm compute VNIC SET"
  applied_acls = ["${opc_compute_acl.scompute-acl.name}"]
  virtual_nics = []
  tags         = ["swarm_compute"]
}

resource "opc_compute_security_protocol" "scompute_port-ssh" {
  name        = "scompute_port-ssh"
  dst_ports   = [22]
  src_ports   = []
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "scompute_port-http" {
  name        = "scompute_port-http"
  dst_ports   = [80]
  src_ports   = []
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "scompute_port-https" {
  name        = "scompute_port-https"
  dst_ports   = [443]
  src_ports   = []
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "scompute_port-8080" {
  name        = "scompute_port-8080"
  dst_ports   = ["8080"]
  src_ports   = []
  ip_protocol = "tcp"
}


resource "opc_compute_security_rule" "scompute-ingress" {
  name               = "scompute-ingress"
  flow_direction     = "ingress"
  acl                = "${opc_compute_acl.scompute-acl.name}"
  security_protocols = ["${opc_compute_security_protocol.scompute_port-ssh.name}","${opc_compute_security_protocol.scompute_port-http.name}","${opc_compute_security_protocol.scompute_port-https.name}","${opc_compute_security_protocol.scompute_port-ssh.name}"]
  #src_ip_address_prefixes=["${opc_compute_ip_address_prefix_set.fa_bastion_subnet_cidr.name}"]
  dst_vnic_set = "${opc_compute_vnic_set.scompute-vnic-set.name}"
}

resource "opc_compute_security_rule" "scompute-egress" {
  name               = "scompute-egress"
  flow_direction     = "egress"
  acl                = "${opc_compute_acl.scompute-acl.name}"
  security_protocols = ["${opc_compute_security_protocol.scompute_port-ssh.name}"]
  src_vnic_set = "${opc_compute_vnic_set.scompute-vnic-set.name}"
  #dst_ip_address_prefixes=["${opc_compute_ip_address_prefix_set.fa_bastion_subnet_cidr.name}"]
}

resource "opc_compute_ip_network_exchange" "scompute_ipexchange" {
  name = "scompute_ipexchange"
}


resource "opc_compute_ip_address_prefix_set" "scompute_subnet_cidr" {
  name     = "scompute_subnet_cidr"
  prefixes = ["${cidrsubnet("10.10.165.0/24", 8,count.index)}"]
  tags                = ["swarm_compute"]
}


resource "opc_compute_ip_network" "scompute-ip-network" {
  name                = "scompute-ip-network"
  description         = "compute for swarm subnet"
  ip_address_prefix   = "${cidrsubnet("10.10.165.0/24",8, count.index)}"
  ip_network_exchange = "${opc_compute_ip_network_exchange.scompute_ipexchange.name}"
  public_napt_enabled = false
  tags                = ["swarm_compute"]
}

