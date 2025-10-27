#!/usr/bin/env bash
set -e

# Konfiguration
GITHUB_USERNAME="simonhansen1999"
REPO_NAME="ha-cloudflare-addon"
ADDON_NAME="ha-cloudflare-addon"
TAG="v1.0.0"

# Opret mapper
mkdir -p "$ADDON_NAME/www"
mkdir -p ".github/workflows"

# Opret standardfiler (eksempel med config.json)
cat > "$ADDON_NAME/config.json" <<'EOF'
{
  "name": "Cloudflare DNS & Tunnel Manager",
  "version": "2.2.0",
  "slug": "cloudflare_dns_tunnel_manager"
}
EOF

# init git, push, tag osv.
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git push -u origin main
git tag "$TAG"
git push origin "$TAG"
