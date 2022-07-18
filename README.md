# Terraform demo for Huawei Cloud and Kubernetes

## Instructions

1. Replace file name of credentials-auto-tfvars with credentials.auto.tfvars and with your credentials.
2. Run **terraform apply**.
3. Login to **docker-instance** and clone repository inside ECS.
4. Restore database with the following commands:
<pre>
    Restore databases in each RDS (input passwords):

    - sed 's@PASSWORD_DATABASE@'"<b>new_db_password</b>"'@' ./initialize-db/emojidb.sql | mysql -u root -h <b>rds_emoji_ip</b> -p
    - sed 's@PASSWORD_DATABASE@'"<b>new_db_password</b>"'@' ./initialize-db/votedb.sql | mysql -u root -h <b>rds_vote_ip</b> -p
</pre>

5. Run kubernetes manifests
