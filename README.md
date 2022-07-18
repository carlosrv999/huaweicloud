# Terraform demo for Huawei Cloud and Kubernetes

## Instructions

1. Replace file name of credentials-auto-tfvars with credentials.auto.tfvars and with your credentials.
2. Restore database with the following commands:
<pre>
    Install MySQL Client to connect to RDS:

    - apt install mysql-client -y

    Restore databases in each RDS:

    - sed 's@PASSWORD_DATABASE@'"<b>new_db_password</b>"'@' ./initialize-db/emojidb.sql | mysql -u root -h <b>rds_emoji_ip</b> -p
    - sed 's@PASSWORD_DATABASE@'"<b>new_db_password</b>"'@' ./initialize-db/votedb.sql | mysql -u root -h <b>rds_vote_ip</b> -p
    
</pre>