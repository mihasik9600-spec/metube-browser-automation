FROM ghcr.io/alexta69/metube:latest

# MUST match the Brainicism POT HTTP Docker tag on Railway (e.g. brainicism/bgutil-ytdlp-pot-provider:1.3.1).
# Mismatch → yt-dlp warns then may fall back to CLI provider and crash. Bump this and the Railway image together.
ARG BGUTIL_PLUGIN_VERSION=1.3.1

# Upgrade yt-dlp to match current YouTube extractors (base image pins via uv; pip needs --break-system-packages on PEP 668).
# No Playwright/Chromium — they are not used by yt-dlp and add weight and attack surface.
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    && python3 -m pip install --upgrade --no-cache-dir --break-system-packages \
        yt-dlp \
        "bgutil-ytdlp-pot-provider==${BGUTIL_PLUGIN_VERSION}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /config && chmod 755 /config

# entrypoint merges optional Netscape cookie file into YTDL_OPTIONS (see docs/METUBE_INTEGRATION.md)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default options (JSON). If /config/youtube_cookies.txt exists, entrypoint sets cookiefile automatically.
# Override YTDL_OPTIONS on Railway only when you need full control (still single-line JSON).
# @see https://github.com/alexta69/metube/wiki/YTDL_OPTIONS-Cookbook
ENV YTDL_OPTIONS='{"socket_timeout":30,"sleep_interval":2,"max_sleep_interval":10,"quiet":true,"http_headers":{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36","Accept-Language":"en-US,en;q=0.9"}}'

EXPOSE 8081

ENTRYPOINT ["/entrypoint.sh"]
