#!/bin/sh
set -e

# yt-dlp tuning lives in Dockerfile ENV YTDL_OPTIONS (JSON). MeTube rejects CLI-style strings there.

# Upstream image layout: WORKDIR /app, app code at app/main.py → path is /app/app/main.py.
# Official entry: tini → docker-entrypoint.sh (chown, bgutil-pot, gosu … python3 app/main.py).
cd /app
exec /usr/bin/tini -g -- /app/docker-entrypoint.sh
