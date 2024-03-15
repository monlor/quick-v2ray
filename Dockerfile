FROM alpine:3.10

LABEL maintainer "me@monlor.com"

ENV TZ Asia/Shanghai

# install caddy
COPY --from=caddy:2.7.6 /usr/bin/caddy /usr/bin/caddy

COPY --from=teddysun/v2ray:5.14.1 /usr/bin/v2ray /usr/bin/v2ray

ADD entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]