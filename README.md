# Terraform demo for Huawei Cloud and Kubernetes

## Instructions

1. Replace file name of credentials-auto-tfvars with credentials.auto.tfvars and with your credentials.
2. Restore database with the following command:
<pre>
    - sed -i 's@PASSWORD_DATABASE@'"<b>new_password</b>"'@' ./initialize-db/emojidb.sql
    - sed -i 's@PASSWORD_DATABASE@'"<b>new_password</b>"'@' ./initialize-db/votedb.sql</pre>