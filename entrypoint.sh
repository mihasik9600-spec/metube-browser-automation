#!/bin/sh
set -e

# Merge optional cookie file + BgUtils POT HTTP base URL into YTDL_OPTIONS (MeTube → yt-dlp).
# POT: https://github.com/Brainicism/bgutil-ytdlp-pot-provider — does not replace cookies if you still mount them.
export YTDL_OPTIONS="$(python3 -c "
import json, os, pathlib

raw = os.environ.get('YTDL_OPTIONS', '{}')
try:
    opts = json.loads(raw)
    if not isinstance(opts, dict):
        opts = {}
except Exception:
    opts = {}

path = (os.environ.get('YOUTUBE_COOKIES_PATH') or '/config/youtube_cookies.txt').strip()
p = pathlib.Path(path)
if p.is_file() and p.stat().st_size > 0:
    opts['cookiefile'] = str(p)

pot_url = (os.environ.get('BGUTIL_POT_BASE_URL') or '').strip()
if pot_url:
    ea = opts.get('extractor_args')
    if not isinstance(ea, dict):
        ea = {}
    pot = ea.get('youtubepot-bgutilhttp')
    if not isinstance(pot, dict):
        pot = {}
    pot['base_url'] = pot_url
    ea['youtubepot-bgutilhttp'] = pot
    opts['extractor_args'] = ea

# Verbose POT logs: https://github.com/yt-dlp/yt-dlp/blob/master/yt_dlp/extractor/youtube/pot/README.md#debugging
trace = (os.environ.get('BGUTIL_POT_TRACE') or '').strip().lower() in ('1', 'true', 'yes')
if trace:
    ea = opts.get('extractor_args')
    if not isinstance(ea, dict):
        ea = {}
    yt = ea.get('youtube')
    if not isinstance(yt, dict):
        yt = {}
    yt['pot_trace'] = True
    ea['youtube'] = yt
    opts['extractor_args'] = ea

print(json.dumps(opts, separators=(',', ':')))
")"

cd /app
exec /usr/bin/tini -g -- /app/docker-entrypoint.sh
