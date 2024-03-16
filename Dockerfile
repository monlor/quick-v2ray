FROM alpine:3.19.1

LABEL maintainer "me@monlor.com"

ENV TZ Asia/Shanghai

COPY --from=teddysun/v2ray:5.14.1 /usr/bin/v2ray /usr/bin/v2ray

COPY --from=ghcr.io/mdp/qrterminal:v3.2.0 /qrterminal /usr/bin/qrterminal

ADD entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]