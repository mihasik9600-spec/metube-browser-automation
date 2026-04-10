FROM ghcr.io/alexta69/metube:latest

# Install Playwright and system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    libxss1 \
    libappindicator1 \
    libindicator7 \
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

# Set environment variables for yt-dlp
ENV YTDL_OPTIONS="--socket-timeout 30 --sleep-interval 2 --max-sleep-interval 10 --extractor-args youtube:player_client=web,android --no-warnings"
ENV BROWSER_EXECUTABLE_PATH="/usr/bin/chromium"

EXPOSE 8081

ENTRYPOINT ["/entrypoint.sh"]
