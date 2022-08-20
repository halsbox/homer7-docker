#!/bin/sh
if [ ! -f .env ]
then
  cp dist.env .env
  grep changeme dist.env | while read -r line ; do
    PASSWORD=$(cat /dev/urandom | tr -cd '[:alnum:]'| tr  -d '\\' | head -c 32)
    sed -i "0,/changeme/s//$PASSWORD/" .env
  done
fi
docker-compose build
export $(grep -v '^#' .env | xargs -d '\n')
mkdir -p ${STORAGE}/grafana
mkdir -p ${STORAGE}/loki
mkdir -p ${STORAGE}/prometheus
chown -R 472:0 ${STORAGE}/grafana
chown -R 10001:10001 ${STORAGE}/loki
chown -R 65534:65534 ${STORAGE}/prometheus
docker-compose up -d
echo "${GRAFANA_TOKEN}" | base64 -d | grep -q '"k":"' && exit 0
GRAFANA_DOCKER_IP=$(docker inspect -f '{{ .NetworkSettings.Networks.homer7.IPAddress }}' grafana)
until $(curl --output /dev/null --silent --head --fail http://${GRAFANA_DOCKER_IP}:${GRAFANA_PORT}/api/health); do
  printf '.'
  sleep 1
done
GRAFANA_KEY=$(curl --silent \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"heplify","role":"Admin"}' \
  http://${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASS}@${GRAFANA_DOCKER_IP}:${GRAFANA_PORT}/api/auth/keys | \
jq -r .key)
sed -i 's@^GRAFANA_TOKEN=.*$@GRAFANA_TOKEN='"$GRAFANA_KEY"'@' .env
echo "please run: set_keys.sh"
