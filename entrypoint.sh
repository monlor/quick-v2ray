#!/bin/bash
# FILE="/etc/Caddy"
DOMAIN="${DOMAIN}"
UUID="${UUID:-$(cat /proc/sys/kernel/random/uuid)}"
ALTER_ID="${ALTER_ID:-64}"
PROXY_PATH="${PROXY_PATH:-/}"
PROXY_PORT="${PROXY_PORT:-80}"

echo "生成Caddyfile..."
cat > /etc/Caddyfile <<'EOF'
${DOMAIN} {
  log ./caddy.log
  proxy ${PROXY_PATH} :${PROXY_PORT} {
    websocket
    header_upstream -Origin
  }
}
EOF

echo "启动caddy..."
caddy start --config /etc/Caddyfile --adapter caddyfile

echo "生成v2ray配置..."
cat > /etc/v2ray/config.json <<-EOF
{
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

cat /etc/v2ray/config.json

echo "启动v2ray..."
/usr/bin/v2ray -config /etc/v2ray/config.json