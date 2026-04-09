- **Production Ready**: Fully tested and polished for Railway deployment

## Environment Variables

- `PORT` (default: 8081) - Web interface port
- `YTDL_OPTIONS` - Custom yt-dlp options (optional, has sensible defaults)
- `BROWSER_EXECUTABLE_PATH` - Path to Chromium browser (auto-detected)

## No Credentials Needed

This image uses headless browser automation, which means:
- ✅ No cookies required
- ✅ No authentication needed
- ✅ No account risk
- ✅ Works with YouTube's bot detection

## Deployment

Deploy to Railway by connecting this repository to a new service and selecting Docker as the build method.

## How It Works

1. Playwright launches a headless Chromium browser
2. yt-dlp uses the browser context to extract video metadata
3. Browser automation bypasses YouTube's rate limiting and bot detection
4. Downloads proceed normally with proper headers and user-agent

## License

MIT
