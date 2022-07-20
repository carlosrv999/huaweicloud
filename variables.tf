data "huaweicloud_compute_instance" "node" {
  name = huaweicloud_cce_node.node_1.name
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "db_root_password" {
  type = string
}

variable "emojivote_db_password" {
  type = string
}

output "rds_emoji_private_ip" {
  value = huaweicloud_rds_instance.rds_emoji.fixed_ip
}

output "rds_vote_private_ip" {
  value = huaweicloud_rds_instance.rds_vote.fixed_ip
}

output "docker_instance_public_ip" {
  value = huaweicloud_vpc_eip.docker_instance_eip.address
}

output "nginx_ingress_controller_ip" {
  value = huaweicloud_vpc_eip.eip_nginx_ingress_controller.address
}
