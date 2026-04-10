FROM ghcr.io/alexta69/metube:latest

# Install Playwright and system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    libxss1 \
    fonts-liberation \
    xdg-utils \
    wget \
    && pip3 install --no-cache-dir playwright \
    && playwright install chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# MeTube parses YTDL_OPTIONS with json.loads() — it must be a JSON object (yt-dlp Python option names), not CLI flags.
# @see https://github.com/alexta69/metube/wiki/YTDL_OPTIONS-Cookbook
ENV YTDL_OPTIONS='{"socket_timeout":30,"sleep_interval":2,"max_sleep_interval":10,"extractor_args":{"youtube":{"player_client":"web,android"}},"quiet":true,"http_headers":{"User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}}'

EXPOSE 8081

ENTRYPOINT ["/entrypoint.sh"]
