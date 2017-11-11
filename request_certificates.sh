#!/usr/bin/bash
set -euo pipefail

usage(){
    cat <<EOF
Usage: $0 <TXT record> <AWS_ACCESS_KEY_ID> <AWS_SECRET_ACCESS_KEY> <LE_EMAIL>

Example: $0 ssldomains.example.com AAAAAAAAAAAAAAAAAAAA 9OZo3Hzic5EwPGLEXAMPLE3YA7aafZi5SPcS1hI8 john@example.com

EOF
    exit 1
}

if [ $# -ne 4 ]; then usage; fi

TXT_RECORD=$1
export AWS_ACCESS_KEY_ID=$2
export AWS_SECRET_ACCESS_KEY=$3
export LE_EMAIL=$4

BASEDIR=$(dirname "$0")
cd $BASEDIR

LEGO_EXISTS=$(stat -c %s ./lego/lego && echo "success" || echo "fail")
if [[ $LEGO_EXISTS == *"fail"* ]]
then
    wget https://github.com/xenolf/lego/releases/download/v0.3.1/lego_linux_amd64.tar.xz
    tar -xJf lego_linux_amd64.tar.xz
    rm -rf lego_linux_amd64.tar.xz
fi

for DOMAIN in $(dig +short TXT $TXT_RECORD|tr -d '"')
do
    CERT_EXISTS=$(stat -c %s certificates/$DOMAIN.crt && echo "success" || echo "fail")

    if [[ $CERT_EXISTS == *"success"* ]]
    then
        ./lego/lego -a --path $PWD --email $LE_EMAIL --domains $DOMAIN --dns route53 renew --days 30
    else
        ./lego/lego -a --path $PWD --email $LE_EMAIL --domains $DOMAIN --dns route53 run
    fi

    cat certificates/$DOMAIN.crt > certificates/$DOMAIN.pem
    cat certificates/$DOMAIN.key >> certificates/$DOMAIN.pem
done
