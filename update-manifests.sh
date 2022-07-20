#!/bin/bash

emoji_ip=$1
vote_ip=$2
emojivote_dbpasswd=$3
region=$4
swr_repo_name=$5

base64pass=$(echo -n $emojivote_dbpasswd | base64)

echo "$(date) Updating manifests file"
sed -i "3s/.*/  MYSQL_HOST: ${emoji_ip}/" ./manifests-emojivote/envs/emoji-db-access-configmap.yaml
sed -i "3s/.*/  MYSQL_HOST: ${vote_ip}/" ./manifests-emojivote/envs/vote-db-access-configmap.yaml
sed -i "4s/.*/  MYSQL_PASSWD: ${base64pass}/" ./manifests-emojivote/envs/db-access-emoji.yaml
sed -i "4s/.*/  MYSQL_PASSWD: ${base64pass}/" ./manifests-emojivote/envs/db-access-vote.yaml
sed -i "/- image:/c\      - image: swr.${region}.myhuaweicloud.com/${swr_repo_name}/webapp-emojivote:latest" ./manifests-emojivote/frontend/frontend-deployment.yaml
echo "$(date) SUCCESS"
