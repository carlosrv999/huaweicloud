#!/bin/bash

AK=$1
SK=$2
swr_repo_name=$3

swr_passwd=$(printf "$AK" | openssl dgst -binary -sha256 -hmac "$SK" | od -An -vtx1 | sed 's/[ \n]//g' | sed 'N;s/\n//')
echo $swr_passwd
