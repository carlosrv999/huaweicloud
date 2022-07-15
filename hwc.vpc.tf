resource "huaweicloud_vpc" "vpc" {
  name = "vpc-tf-demo"
  cidr = "10.210.0.0/16"
}

resource "huaweicloud_vpc_subnet" "subnet-az1-private" {
  name              = "subnet-private-az1-tf-demo"
  cidr              = "10.210.0.0/24"
  availability_zone = "la-south-2a"
  gateway_ip        = "10.210.0.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_vpc_subnet" "subnet-az2-private" {
  name              = "subnet-private-az2-tf-demo"
  cidr              = "10.210.1.0/24"
  availability_zone = "la-south-2b"
  gateway_ip        = "10.210.1.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_vpc_subnet" "subnet-az1-public" {
  name              = "subnet-public-az1-tf-demo"
  cidr              = "10.210.2.0/24"
  availability_zone = "la-south-2a"
  gateway_ip        = "10.210.2.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_vpc_subnet" "subnet-az2-public" {
  name              = "subnet-public-az2-tf-demo"
  cidr              = "10.210.3.0/24"
  availability_zone = "la-south-2b"
  gateway_ip        = "10.210.3.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_networking_secgroup" "secgroup_ssh" {
  name                 = "sg-tf-allow-ssh"
  description          = "Allow SSH from anywhere"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_ssh" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_ssh.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow SSH from anywhere"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_outgoing" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_ssh.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow outgoing communication"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_self" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_ssh.id
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = huaweicloud_networking_secgroup.secgroup_ssh.id
  description       = "Allow communication inside security group"
}

resource "huaweicloud_vpc_eip" "eip_cce_cluster" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    share_type  = "PER"
    name        = "bandwidth-cce"
    size        = 10
    charge_mode = "traffic"
  }
}
