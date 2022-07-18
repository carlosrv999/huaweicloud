resource "huaweicloud_compute_keypair" "keypair_demo" {
  name     = "keypair-terraform"
  key_file = "keypair-terraform.pem"
}

resource "huaweicloud_vpc_eip" "docker_instance_eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "docker-instance"
    size        = 50
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_compute_instance" "ssh_docker_instance" {
  name               = "docker-instance"
  image_name         = "Ubuntu 20.04 server 64bit"
  flavor_id          = "s6.large.2"
  security_group_ids = [huaweicloud_networking_secgroup.secgroup_ssh.id, huaweicloud_networking_secgroup.secgroup_nodejs.id]
  key_pair           = huaweicloud_compute_keypair.keypair_demo.name
  system_disk_size   = 100
  system_disk_type   = "GPSSD"
  user_data          = "#!/bin/bash\ncurl -fsSL https://get.docker.com -o /root/get-docker.sh\nsh /root/get-docker.sh\ncurl -sL https://deb.nodesource.com/setup_16.x | bash -\napt-get install nodejs -y"

  network {
    uuid = huaweicloud_vpc_subnet.subnet-az1-private.id
  }
}

resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = huaweicloud_vpc_eip.docker_instance_eip.address
  instance_id = huaweicloud_compute_instance.ssh_docker_instance.id
}