  
#creating vpc
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames=true 
  tags = {
    Name = "vpc1"
  }
}

#public subnet
resource "aws_subnet" "public1" {
  vpc_id = "${aws_vpc.vpc1.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
    tags = {
    Name = "public1"
  }
}

#private subnet
resource "aws_subnet" "private1" {
  vpc_id = "${aws_vpc.vpc1.id}"
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
    tags = {
    Name = "private1"
  }
}

#internet gateway
resource "aws_internet_gateway" "gw1" {
    vpc_id = "${aws_vpc.vpc1.id}"
      tags = {
    Name = "gw1"
  }
    
    }

#public route table
resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.vpc1.id}"     
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.gw1.id}" 
    }

    tags = {
        Name = "public-rt"
    }
    
}

#public rotute table assiosation  
resource "aws_route_table_association" "public1" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

#elastic ip    
resource "aws_eip" "elasticip" {
    tags = {
        Name = "eip1"
    }
}



#NAT
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.elasticip.id}"
  subnet_id     = "${aws_subnet.public1.id}"
  tags = {
        Name = "natgw1"
    }
}

#privte route table
resource "aws_route_table" "private-rt" {
    vpc_id = "${aws_vpc.vpc1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.natgw.id}"
    }
    tags = {
        Name = "private-rt"
    }
  }

#private rotute table assiosation 
resource "aws_route_table_association" "private1" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}  

  #Security group 
    resource "aws_security_group" "sg1" {
    vpc_id = "${aws_vpc.vpc1.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
}



