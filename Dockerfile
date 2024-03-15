FROM abiosoft/caddy:builder as builder

# add this line before you run `/bin/sh /usr/bin/builder.sh`
ADD https://raw.githubusercontent.com/jeffreystoke/caddy-docker/master/builder/builder.sh /usr/bin/builder.sh

ARG version="1.0.3"
ARG plugins=""
ARG enable_telemetry="false"

RUN VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=${enable_telemetry} /bin/sh /usr/bin/builder.sh

FROM alpine:3.10

LABEL maintainer "me@monlor.com"

WORKDIR /srv

ENV TZ Asia/Shanghai
ENV V2RAY_VERSION v4.28.2
ENV V2RAY_LOG_DIR /var/log/v2ray
ENV V2RAY_CONFIG_DIR /etc/v2ray/
ENV V2RAY_DOWNLOAD_URL https://github.com/v2ray/v2ray-core/releases/download/${V2RAY_VERSION}/v2ray-linux-64.zip

RUN apk upgrade --update \
    && apk add \
        bash \
        tzdata \
        curl \
    && mkdir -p \ 
        ${V2RAY_LOG_DIR} \
        ${V2RAY_CONFIG_DIR} \
        /tmp/v2ray \
    && curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip ${V2RAY_DOWNLOAD_URL} \
    && pwd \
    && unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray/ \
    && mv /tmp/v2ray/v2ray /usr/bin \
    && mv /tmp/v2ray/v2ctl /usr/bin \
    && mv /tmp/v2ray/vpoint_vmess_freedom.json /etc/v2ray/config.json \
    && chmod +x /usr/bin/v2ray \
    && chmod +x /usr/bin/v2ctl \
    && apk del curl \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /tmp/v2ray /var/cache/apk/*

# Let's Encrypt Agreement
ENV ACME_AGREE="false"

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

COPY index.html /srv/index.html

ADD entrypoint.sh /caddy.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]