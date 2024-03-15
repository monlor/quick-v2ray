FROM caddy:2.7.6 as caddy

FROM teddysun/v2ray:5.14.1 as v2ray

FROM alpine:3.10

LABEL maintainer "me@monlor.com"

ENV TZ Asia/Shanghai

# install caddy
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

COPY --from=v2ray /usr/bin/v2ray /usr/bin/v2ray

ADD entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]