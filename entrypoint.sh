#!/bin/sh
set -e

# System-wide yt-dlp config so MeTube's non-root user (PUID/PGID) still sees it.
# (Configs under /root/.config are ignored after docker-entrypoint switches to PUID.)
mkdir -p /etc/yt-dlp
cat > /etc/yt-dlp/config << 'EOF'
# YouTube / network tuning (merged with MeTube's YTDL_OPTIONS env)
--extractor-args youtube:player_client=web,android
--socket-timeout 30
--sleep-interval 2
--max-sleep-interval 10
--no-warnings
--user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
EOF

# Upstream image layout: WORKDIR /app, app code at app/main.py → path is /app/app/main.py.
# Official entry: tini → docker-entrypoint.sh (chown, bgutil-pot, gosu … python3 app/main.py).
cd /app
exec /usr/bin/tini -g -- /app/docker-entrypoint.sh
