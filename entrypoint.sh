#!/bin/sh
DOMAIN="${DOMAIN:-example.com}"
UUID="${UUID:-$(cat /proc/sys/kernel/random/uuid)}"
ALTER_ID="${ALTER_ID:-64}"
PROXY_PATH="${PROXY_PATH:-/}"
PROXY_PORT="${PROXY_PORT:-80}"

echo "生成Caddyfile..."
# https://guide.v2fly.org/advanced/wss_and_web.html#%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%85%8D%E7%BD%AE
cat > /etc/Caddyfile <<-EOF
http://${DOMAIN}:${PROXY_PORT} {
    log {
        output file /var/log/caddy.log
    }
    @ws {
        path ${PROXY_PATH}
        header Connection Upgrade
        header Upgrade websocket
    }
    reverse_proxy @ws localhost:1888
}
EOF

echo "启动caddy..."
caddy start --config /etc/Caddyfile --adapter caddyfile

echo "生成v2ray配置..."
cat > /etc/v2ray.json <<-EOF
{
  "inbounds": [
    {
      "port": 1888,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "alterId": ${ALTER_ID}
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
            "path": "${PROXY_PATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

echo "v2ray url: vmess://$(echo auto:${UUID}@${DOMAIN}:${PROXY_PORT} | base64)?remarks=${DOMAIN}&obfsParam=www.microsoft.com&path=/&obfs=websocket&tfo=1&alterId=${ALTER_ID}"

echo "启动v2ray..."
/usr/bin/v2ray -config /etc/v2ray.json