#!/bin/bash

AK=$1
SK=$2
swr_repo_name=$3
region=$4
nginx_ingress_eip=$5
swr_passwd=$(printf "$AK" | openssl dgst -binary -sha256 -hmac "$SK" | od -An -vtx1 | sed 's/[ \n]//g' | sed 'N;s/\n//')
echo $swr_passwd

git -C /tmp clone https://github.com/carlosrv999/front-vote.git
git -C /tmp clone https://github.com/carlosrv999/emoji-api.git
git -C /tmp clone https://github.com/carlosrv999/vote-api.git
git -C /tmp clone https://github.com/carlosrv999/vote-bot.git

# Login to repository and push image. Refer to https://support.huaweicloud.com/intl/en-us/usermanual-swr/swr_01_1000.html

docker build -t swr.${region}.myhuaweicloud.com/$swr_repo_name/webapp-emojivote:latest /tmp/front-vote
docker build -t swr.${region}.myhuaweicloud.com/$swr_repo_name/emojiapi:latest /tmp/emoji-api
docker build -t swr.${region}.myhuaweicloud.com/$swr_repo_name/voteapi:latest /tmp/vote-api
docker build -t swr.${region}.myhuaweicloud.com/$swr_repo_name/votebot:latest /tmp/vote-bot
docker login -u ${region}@$AK -p $swr_passwd swr.${region}.myhuaweicloud.com
docker push swr.${region}.myhuaweicloud.com/$swr_repo_name/webapp-emojivote:latest
docker push swr.${region}.myhuaweicloud.com/$swr_repo_name/emojiapi:latest
docker push swr.${region}.myhuaweicloud.com/$swr_repo_name/voteapi:latest
docker push swr.${region}.myhuaweicloud.com/$swr_repo_name/votebot:latest
