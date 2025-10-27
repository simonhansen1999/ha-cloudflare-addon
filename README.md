# Cloudflare DNS & Tunnel Manager

Home Assistant Add-on til at opdatere DNS og oprette Cloudflare Tunnel automatisk.

## Installation

1. Tilføj GitHub repo i HA Add-on Store:
   `https://github.com/<username>/<repo>`
2. Installer add-on’en “Cloudflare DNS & Tunnel Manager”
3. Konfigurer options:
```json
{
  "hostname": "ha.site.dk",
  "service_port": 8123,
  "api_token": "<Cloudflare API Token>"
}
