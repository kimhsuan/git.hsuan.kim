#!/usr/bin/env bash

action=${1-}

domain=git.hsuan.kim

function certonly() {
  sudo mkdir -p /data/html/.well-known/acme-challenge
  docker run -it --rm --name certbot \
      -v "/data/letsencrypt:/etc/letsencrypt" \
      -v "/data/html:/usr/local/openresty/nginx/html" \
      -v "/var/log/letsencrypt:/var/log/letsencrypt" \
      certbot/certbot certonly --webroot \
      -w /usr/local/openresty/nginx/html -d ${domain} \
      --agree-tos --register-unsafely-without-email
  sudo cp -rf /data/letsencrypt/archive/${domain} /data/ssl
}

function renew() {
  docker run -it --rm --name certbot \
      -v "/data/letsencrypt:/etc/letsencrypt" \
      -v "/data/html:/usr/local/openresty/nginx/html" \
      -v "/var/log/letsencrypt:/var/log/letsencrypt" \
      certbot/certbot renew
  sudo cp -rf /data/letsencrypt/archive/${domain} /data/ssl
}

function main() {
  case "${action}" in
  certonly)
    certonly
    ;;
  renew)
    renew
    ;;
  *)
    renew
    ;;
  esac
}

main "$@"
