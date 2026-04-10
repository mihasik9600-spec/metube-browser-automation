#!/bin/bash
set -e

# Create yt-dlp config directory
mkdir -p /root/.config/yt-dlp

# Create yt-dlp config file with browser automation settings
cat > /root/.config/yt-dlp/config.txt << 'EOF'
# Browser automation for YouTube
--extractor-args youtube:player_client=web,android
--socket-timeout 30
--sleep-interval 2
--max-sleep-interval 10
--no-warnings
--user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
EOF

# Delegate to the base image's original metube entrypoint.
# The alexta69/metube image runs the app as a plain script from /app,
# not as an installed Python package, so we must invoke it that way.
exec python3 /app/main.py
