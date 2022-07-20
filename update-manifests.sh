#!/bin/bash

emoji_ip=$1
vote_ip=$2
emojivote_dbpasswd=$3

base64pass=$(echo -n $emojivote_dbpasswd | base64)

echo "$(date) Updating manifests file"
sed -i "3s/.*/  MYSQL_HOST: ${emoji_ip}/" ./manifests-emojivote/envs/emoji-db-access-configmap.yaml
sed -i "3s/.*/  MYSQL_HOST: ${vote_ip}/" ./manifests-emojivote/envs/vote-db-access-configmap.yaml
sed -i "4s/.*/  MYSQL_PASSWD: ${base64pass}/" ./manifests-emojivote/envs/db-access-emoji.yaml
sed -i "4s/.*/  MYSQL_PASSWD: ${base64pass}/" ./manifests-emojivote/envs/db-access-vote.yaml
echo "$(date) SUCCESS"
