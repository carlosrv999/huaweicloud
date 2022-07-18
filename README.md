# Terraform demo for Huawei Cloud and Kubernetes

## Instructions

1. Replace file name of credentials-auto-tfvars with credentials.auto.tfvars and with your credentials.
2. Restore database with the following command:
    - sed -i 's@PASSWORD_DATABASE@'"\<new-password\>"'@' ./initialize-db/emojidb.sql
    - sed -i 's@PASSWORD_DATABASE@'"\<new-password\>"'@' ./initialize-db/votedb.sql