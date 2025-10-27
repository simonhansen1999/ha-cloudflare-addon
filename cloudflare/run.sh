#!/usr/bin/env sh
set -e

mkdir -p /data/cloudflared

# Download cloudflared if it does not exist
if [ ! -f /usr/local/bin/cloudflared ]; then
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
    chmod +x /usr/local/bin/cloudflared
fi

# Run Python app
exec python3 /app/app.py
