FROM ghcr.io/alexta69/metube:latest

# Install Playwright and system dependencies; upgrade yt-dlp to match current YouTube extractors.
# Base MeTube pins yt-dlp via uv; --break-system-packages is required on PEP 668 images when using pip.
RUN apt-get update && apt-get install -y \
    python3-pip \
    libxss1 \
    fonts-liberation \
    xdg-utils \
    wget \
    && pip3 install --no-cache-dir playwright \
    && playwright install chromium \
    && python3 -m pip install --upgrade --no-cache-dir --break-system-packages yt-dlp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# MeTube parses YTDL_OPTIONS with json.loads() — JSON object only (not CLI flags).
# Do not force youtube player_client here: YouTube + yt-dlp change often; stale clients cause
# "Skipping unsupported client …" and worse bot errors. Override only via Railway if you follow yt-dlp release notes.
# For datacenter IPs, add "cookiefile":"/path/to/netscape.txt" once export is mounted in the container.
# @see https://github.com/alexta69/metube/wiki/YTDL_OPTIONS-Cookbook
ENV YTDL_OPTIONS='{"socket_timeout":30,"sleep_interval":2,"max_sleep_interval":10,"quiet":true,"http_headers":{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36","Accept-Language":"en-US,en;q=0.9"}}'

EXPOSE 8081

ENTRYPOINT ["/entrypoint.sh"]
