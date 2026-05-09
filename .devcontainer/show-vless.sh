#!/bin/sh
set -eu

UUID="${G2RAY_UUID:-550e8400-e29b-41d4-a716-446655440000}"
HOST="${CODESPACE_NAME:-replace-with-your-codespace-name}-443.app.github.dev"
PATH_RAW="/"
PATH_ENCODED="%2F"
FALLBACK_IPS="${G2RAY_FALLBACK_IPS:-63.141.252.203 50.7.5.83 94.130.50.12}"

printf '\nVLESS LINKS\n'
printf '1) DNS/Shecan mode (recommended for outbound on your own server):\n'
printf 'vless://%s@%s:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=%s&path=%s#ghtun-dns\n\n' "$UUID" "$HOST" "$HOST" "$PATH_ENCODED"

printf '2) Direct-IP fallback links (if DNS route is unstable):\n'
i=1
for ip in $FALLBACK_IPS; do
  printf 'vless://%s@%s:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=%s&path=%s#ghtun-ip-%d\n' "$UUID" "$ip" "$HOST" "$PATH_ENCODED" "$i"
  i=$((i + 1))
done

cat <<EOF

Xray outbound snippet for a server that uses Shecan DNS:
{
  "dns": {
    "servers": [
      "178.22.122.100",
      "185.51.200.2"
    ],
    "queryStrategy": "UseIPv4"
  },
  "outbounds": [
    {
      "tag": "g2ray-out",
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "$HOST",
            "port": 443,
            "users": [
              {
                "id": "$UUID",
                "encryption": "none"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$HOST",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        },
        "xhttpSettings": {
          "mode": "packet-up",
          "path": "$PATH_RAW"
        },
        "sockopt": {
          "domainStrategy": "UseIPv4"
        }
      }
    }
  ]
}
EOF
