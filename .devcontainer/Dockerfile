FROM debian:bookworm-slim

COPY install.sh /app/install.sh

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /app/install.sh && /app/install.sh
COPY config.json /etc/config.json

RUN printf '%s\n' 'if [ -z "${CODESPACE_NAME}" ]; then' '  echo -e "\n⚠️  NOT RUNNING IN CODESPACES"' '  echo -e "Please update SERVER_IP in config or run in GitHub Codespaces"' 'else' '  echo -e "\n✅ VLESS LINK:"' '  echo -e "vless://550e8400-e29b-41d4-a716-446655440000@${CODESPACE_NAME}.github.dev:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${CODESPACE_NAME}.github.dev&path=%2F#ghtun"' 'fi' >> /etc/bash.bashrc

CMD ["/usr/local/bin/xray", "-c", "/etc/config.json"]
