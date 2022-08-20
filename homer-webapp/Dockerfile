FROM node:12-alpine as webapp
ENV BUILD 20220808-001
RUN apk add git && git clone -b custom_qos_tab_defaults https://github.com/halsbox/homer-ui /app
WORKDIR /app
RUN npm install && npm install -g @angular/cli && npm run build

FROM golang:alpine as webapi
ENV BUILD 20220808-001
RUN apk --update add git make && git clone https://github.com/halsbox/homer-app /homer-app
WORKDIR /homer-app
RUN make modules && make all

FROM alpine
WORKDIR /
RUN apk --update add bash sed
RUN mkdir -p /usr/local/homer
COPY --from=webapi /homer-app/homer-app .
COPY --from=webapi /homer-app/docker/webapp_config.json /usr/local/homer/etc/webapp_config.json
COPY --from=webapi /homer-app/swagger.json /usr/local/homer/etc/swagger.json
COPY --from=webapp /app/dist/homer-ui /usr/local/homer/dist
COPY --from=webapi /homer-app/docker/docker-entrypoint.sh /
COPY --from=webapi /homer-app/docker/docker-entrypoint.d/* /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/* /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/homer-app", "-webapp-config-path=/usr/local/homer/etc"]
