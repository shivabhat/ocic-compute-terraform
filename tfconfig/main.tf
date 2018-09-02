provider "opc" {
  user            = "${var.user}"
  password        = "${var.password}"
  identity_domain = "${var.identity_domain}" #"586997211"
  #endpoint        = "https://compute.${var.region}.oraclecloud.com/"
  endpoint        = "${var.compute_rest_endpoint}"
  max_retries     = 3
  insecure        = true
}



