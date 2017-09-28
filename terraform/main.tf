provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "golang-web-server-tf-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name = "golang-web-server-tf-vpc"
  }
}

resource "aws_subnet" "golang-web-server-public-web" {
  vpc_id                  = "${aws_vpc.golang-web-server-tf-vpc.id}"
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags {
    Name = "golang-web-server-tf-public-web"
  }
}

resource "aws_internet_gateway" "golang-web-server-gw" {
  vpc_id = "${aws_vpc.golang-web-server-tf-vpc.id}"
  tags {
    Name = "golang-web-server-tf-gw"
  }
}

resource "aws_route_table" "golang-web-server-public-rtb" {
  vpc_id = "${aws_vpc.golang-web-server-tf-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.golang-web-server-gw.id}"
  }
  tags {
    Name = "golang-web-server-tf-rtb"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = "${aws_subnet.golang-web-server-public-web.id}"
  route_table_id = "${aws_route_table.golang-web-server-public-rtb.id}"
}

resource "aws_security_group" "app" {
  name        = "golang-web-server-tf-web"
  description = "It is a security group on http of golang-web-server-tf-vpc"
  vpc_id      = "${aws_vpc.golang-web-server-tf-vpc.id}"
  tags {
    Name = "tf_web"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_security_group_rule" "web" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_security_group_rule" "all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_key_pair" "auth" {
  key_name   = "golang-web-server"
  public_key = "${file("~/.ssh/golang-web-server")}"
}

resource "aws_instance" "golang-web-server-tf-instance" {
  ami                         = "ami-8422ebe2"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.app.id}"]
  subnet_id                   = "${aws_subnet.golang-web-server-public-web.id}"
  associate_public_ip_address = "true"
  key_name                    = "${aws_key_pair.auth.id}"
  root_block_device = {
    volume_type = "gp2"
    volume_size = "20"
  }
  ebs_block_device = {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = "100"
  }
}
