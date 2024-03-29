#!/bin/sh
DOMAIN="${DOMAIN:-example.com}"
UUID="${UUID:-$(cat /proc/sys/kernel/random/uuid)}"
ALTER_ID="${ALTER_ID:-64}"
PROXY_PATH="${PROXY_PATH:-/}"
PROXY_PORT="${PROXY_PORT:-80}"

export V2RAY_VMESS_AEAD_FORCED=${V2RAY_VMESS_AEAD_FORCED:-false}

echo "生成v2ray配置..."
cat > /etc/v2ray.json <<-EOF
{
  "log": {
    "loglevel": "${LOG_LEVEL:-error}"
  },
  "inbounds": [
    {
      "port": ${PROXY_PORT},
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

v2ray_url="vmess://$(echo auto:${UUID}@${DOMAIN}:${PROXY_PORT} | base64)?remarks=${DOMAIN}&obfsParam=www.microsoft.com&path=/&obfs=websocket&tfo=1&alterId=${ALTER_ID}"

echo "v2ray url: ${v2ray_url}"

echo "v2ray qrcode:"
qrterminal ${v2ray_url}

echo "启动v2ray..."
/usr/bin/v2ray run -config /etc/v2ray.json