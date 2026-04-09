#!/bin/bash
set -e

# Configure yt-dlp to use browser automation for YouTube
export YTDL_OPTIONS="${YTDL_OPTIONS:---socket-timeout 30 --sleep-interval 2 --max-sleep-interval 10 --extractor-args youtube:player_client=web,android --no-warnings}"

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

# Start metube with the original entrypoint
exec /usr/local/bin/python3 -m metube.main
