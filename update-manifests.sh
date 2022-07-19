emoji_ip=$1
vote_ip=$2

sed -i "3s/.*/  MYSQL_HOST: ${emoji_ip}/" ./manifests-emojivote/envs/emoji-db-access-configmap.yaml
sed -i "3s/.*/  MYSQL_HOST: ${vote_ip}/" ./manifests-emojivote/envs/vote-db-access-configmap.yaml
