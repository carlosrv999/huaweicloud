resource "huaweicloud_vpc" "vpc" {
  name = "vpc-tf-demo"
  cidr = "10.210.0.0/16"
}

resource "huaweicloud_vpc_subnet" "subnet-az1-private" {
  name              = "subnet-private-az1-tf-demo"
  cidr              = "10.210.0.0/24"
  availability_zone = "${var.region}a"
  gateway_ip        = "10.210.0.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_vpc_subnet" "subnet-az2-private" {
  name              = "subnet-private-az2-tf-demo"
  cidr              = "10.210.1.0/24"
  availability_zone = "${var.region}b"
  gateway_ip        = "10.210.1.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_vpc_subnet" "subnet-az1-public" {
  name              = "subnet-public-az1-tf-demo"
  cidr              = "10.210.2.0/24"
  availability_zone = "${var.region}a"
  gateway_ip        = "10.210.2.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_vpc_subnet" "subnet-az2-public" {
  name              = "subnet-public-az2-tf-demo"
  cidr              = "10.210.3.0/24"
  availability_zone = "${var.region}b"
  gateway_ip        = "10.210.3.1"
  vpc_id            = huaweicloud_vpc.vpc.id
}

resource "huaweicloud_networking_secgroup" "secgroup_ssh" {
  name                 = "sg-tf-allow-ssh"
  description          = "Allow SSH from anywhere"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup" "secgroup_nodejs" {
  name                 = "sg-tf-allow-nodejs"
  description          = "Allow nodejs tcp 3000 from anywhere"
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup" "secgroup_rds" {
  name                 = "sg-tf-rds-pods"
  description          = "Allow pods to access RDS"
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

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_nodejs" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_nodejs.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow nodejs tcp 3000 from anywhere"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_pods_rds" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_rds.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_ip_prefix  = huaweicloud_cce_cluster.cluster_cce.container_network_cidr
  description       = "Allow pods to access RDS"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_nodes_rds" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_rds.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_group_id   = sort(data.huaweicloud_compute_instance.node.security_group_ids)[0]
  description       = "Allow nodes to access RDS"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_docker_instance" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_rds.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_group_id   = huaweicloud_networking_secgroup.secgroup_nodejs.id
  description       = "Allow docker instance to access RDS"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_rds_out" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_rds.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow outgoing communication"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule_allow_rds_self" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_rds.id
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = huaweicloud_networking_secgroup.secgroup_rds.id
  description       = "Allow communication inside security group"
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

resource "huaweicloud_vpc_eip" "eip_nginx_ingress_controller" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    share_type  = "PER"
    name        = "bandwidth-nginx-ingress"
    size        = 100
    charge_mode = "traffic"
  }
}

resource "huaweicloud_lb_loadbalancer" "elb_nginx_ingress_controller" {
  name          = "elb-tf-nginx-ingress-controller-k8s"
  vip_subnet_id = huaweicloud_vpc_subnet.subnet-az2-public.subnet_id
}

resource "huaweicloud_vpc_eip_associate" "elb_nginx_eip_associate" {
  public_ip = huaweicloud_vpc_eip.eip_nginx_ingress_controller.address
  port_id   = huaweicloud_lb_loadbalancer.elb_nginx_ingress_controller.vip_port_id
}
