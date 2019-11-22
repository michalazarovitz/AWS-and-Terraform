provider "aws" {
    region = "us-east-1"
    
}

#web Server
resource "aws_instance" "webserver" {
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public1.id}"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  tags = {
    Name = "web server"     
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = keypair1

  }


}

#db server 
resource "aws_instance" "db" {
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.private1.id}"
  vpc_security_group_ids = [aws_security_group.sg1.id]

tags = {
    Name = "db"      
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = keypair1

  }
}