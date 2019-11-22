resource "tls_private_key" "keypair1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair1" {
  key_name   = "keypair1"
  public_key = "${tls_private_key.keypair1.public_key_openssh}"
}

resource "local_file" "keypair1" {
  sensitive_content  = "${tls_private_key.keypair1.private_key_pem}"
  filename           = "keypair1.pem"
}