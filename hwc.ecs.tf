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
  user_data          = "#!/bin/bash\ncurl -fsSL https://get.docker.com -o /root/get-docker.sh\nsh /root/get-docker.sh\ncurl -sL https://deb.nodesource.com/setup_16.x | bash -\napt-get install nodejs -y\napt-get install mysql-client -y"

  network {
    uuid = huaweicloud_vpc_subnet.subnet-az1-private.id
  }
}

resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = huaweicloud_vpc_eip.docker_instance_eip.address
  instance_id = huaweicloud_compute_instance.ssh_docker_instance.id
}

resource "null_resource" "execute_commands" {
  provisioner "remote-exec" {
    connection {
      host        = "${huaweicloud_vpc_eip.docker_instance_eip.address}"
      user        = "root"
      type        = "ssh"
      private_key = "${file("./keypair-terraform.pem")}"
      timeout     = "2m"
    }

    inline = [
      "git clone https://github.com/carlosrv999/huaweicloud.git",
      "cd huaweicloud",
      "sed 's@PASSWORD_DATABASE@'\"${var.emojivote_db_password}\"'@' ./initialize-db/emojidb.sql | mysql -u root -h ${huaweicloud_rds_instance.rds_emoji.fixed_ip} -p${var.db_root_password}",
      "sed 's@PASSWORD_DATABASE@'\"${var.emojivote_db_password}\"'@' ./initialize-db/votedb.sql | mysql -u root -h ${huaweicloud_rds_instance.rds_vote.fixed_ip} -p${var.db_root_password}",
      "bash ./upload-image.sh ${var.access_key} ${var.secret_key} ${var.swr_repo_name} ${var.region} ${huaweicloud_vpc_eip.eip_nginx_ingress_controller.address}"
    ]
  }

  depends_on = [
    huaweicloud_compute_instance.ssh_docker_instance,
  ]
}
