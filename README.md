# metube-browser-automation

A production-ready [MeTube](https://github.com/alexta69/metube) Docker image enhanced with Playwright browser automation to bypass YouTube's rate limiting and bot detection — no credentials or cookies required.

## Features

- **Browser Automation**: Uses headless Chromium via Playwright to simulate a real browser session
- **No Credentials Needed**: Works without YouTube accounts, cookies, or API keys
- **Bot Detection Bypass**: Proper user-agent and extractor args defeat YouTube's rate limiting
- **Production Ready**: Fully tested and polished for Railway deployment

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8081` | Web interface port |
| `YTDL_OPTIONS` | *(see Dockerfile)* | Custom yt-dlp options (optional, has sensible defaults) |
| `BROWSER_EXECUTABLE_PATH` | `/usr/bin/chromium` | Path to Chromium browser executable |

## No Credentials Needed

This image uses headless browser automation, which means:
- ✅ No cookies required
- ✅ No authentication needed
- ✅ No account risk
- ✅ Works with YouTube's bot detection

## Deployment

Deploy to Railway by connecting this repository to a new service and selecting **Docker** as the build method. The service will listen on port `8081`.

## How It Works

1. `entrypoint.sh` writes an optimised `yt-dlp` config to `/root/.config/yt-dlp/config.txt`
2. Playwright launches a headless Chromium browser in the background
3. yt-dlp uses the browser context to extract video metadata with a realistic user-agent
4. Browser automation bypasses YouTube's rate limiting and bot detection
5. Downloads proceed normally through the MeTube web interface

## License

MIT
