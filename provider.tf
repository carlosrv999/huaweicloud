terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.38.1"
    }
  }
}

provider "huaweicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
