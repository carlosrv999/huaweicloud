resource "huaweicloud_rds_instance" "rds_emoji" {
  name              = "rds-tf-emoji"
  flavor            = "rds.mysql.n1.large.2"
  vpc_id            = huaweicloud_vpc.vpc.id
  subnet_id         = huaweicloud_vpc_subnet.subnet-az2-private.id
  security_group_id = huaweicloud_networking_secgroup.secgroup_rds.id
  availability_zone = ["${var.region}b"]

  db {
    type     = "MySQL"
    version  = "8.0"
    password = var.db_root_password
  }

  volume {
    type = "CLOUDSSD"
    size = 40
  }

}
