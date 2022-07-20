#!/bin/bash

AK=$1
SK=$2
swr_repo_name=$3
region=$4
swr_passwd=$(printf "$AK" | openssl dgst -binary -sha256 -hmac "$SK" | od -An -vtx1 | sed 's/[ \n]//g' | sed 'N;s/\n//')
echo $swr_passwd

git -C /tmp clone https://github.com/carlosrv999/front-vote.git

# Login to repository and push image. Refer to https://support.huaweicloud.com/intl/en-us/usermanual-swr/swr_01_1000.html

docker build -t swr.${region}.myhuaweicloud.com/$swr_repo_name/webapp-emojivote:latest /tmp/front-vote
docker login -u ${region}@$AK -p $swr_passwd swr.${region}.myhuaweicloud.com
docker push swr.${region}.myhuaweicloud.com/$swr_repo_name/webapp-emojivote:latest
