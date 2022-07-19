resource "huaweicloud_cce_cluster" "cluster_cce" {
  name                   = "cce-tf-demo-utp"
  flavor_id              = "cce.s1.small"
  vpc_id                 = huaweicloud_vpc.vpc.id
  subnet_id              = huaweicloud_vpc_subnet.subnet-az1-private.id
  container_network_cidr = "172.16.0.0/16"
  container_network_type = "overlay_l2"
  cluster_version        = "v1.21"
  service_network_cidr   = "10.247.0.0/16"
  eip                    = huaweicloud_vpc_eip.eip_cce_cluster.address
}

resource "huaweicloud_cce_node" "node_1" {
  cluster_id        = huaweicloud_cce_cluster.cluster_cce.id
  availability_zone = "${var.region}a"
  flavor_id         = "c6s.xlarge.2"
  key_pair          = huaweicloud_compute_keypair.keypair_demo.name
  os                = "EulerOS 2.9"
  subnet_id         = huaweicloud_vpc_subnet.subnet-az1-private.id

  root_volume {
    extend_params  = {}
    hw_passthrough = false
    size           = 40
    volumetype     = "SAS"
  }

  data_volumes {
    extend_params  = {}
    hw_passthrough = false
    size           = 100
    volumetype     = "SAS"
  }

}

resource "huaweicloud_cce_node" "node_2" {
  cluster_id        = huaweicloud_cce_cluster.cluster_cce.id
  availability_zone = "${var.region}b"
  flavor_id         = "c6s.xlarge.2"
  key_pair          = huaweicloud_compute_keypair.keypair_demo.name
  os                = "EulerOS 2.9"
  subnet_id         = huaweicloud_vpc_subnet.subnet-az2-private.id

  root_volume {
    extend_params  = {}
    hw_passthrough = false
    size           = 40
    volumetype     = "SAS"
  }

  data_volumes {
    extend_params  = {}
    hw_passthrough = false
    size           = 100
    volumetype     = "SAS"
  }

}

resource "local_file" "create_kubeconfig_file" {
  content = huaweicloud_cce_cluster.cluster_cce.kube_config_raw
  filename = "kubeconfig.json"
}
