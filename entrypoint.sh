#!/bin/sh
set -e

# Merge optional cookie file + BgUtils POT HTTP base URL into YTDL_OPTIONS (MeTube → yt-dlp).
# POT: https://github.com/Brainicism/bgutil-ytdlp-pot-provider
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

def normalize_pot_url(u):
    u = (u or '').strip()
    if not u:
        return ''
    if '://' not in u:
        u = 'http://' + u
    return u

pot_url = bgutil-ytdlp-pot-provider.railway.internal

ea = opts.get('extractor_args')
if not isinstance(ea, dict):
    ea = {}

# Drop broken POT blocks (empty base_url causes: Unsupported url scheme \"\")
pot = ea.get('youtubepot-bgutilhttp')
if isinstance(pot, dict):
    existing = normalize_pot_url(str(pot.get('base_url') or ''))
    if not existing and not pot_url:
        ea.pop('youtubepot-bgutilhttp', None)
    elif pot_url:
        pot['base_url'] = pot_url
        ea['youtubepot-bgutilhttp'] = pot
    elif existing:
        pot['base_url'] = existing
        ea['youtubepot-bgutilhttp'] = pot
elif pot_url:
    ea['youtubepot-bgutilhttp'] = {'base_url': pot_url}

# Second pass: never leave youtubepot-bgutilhttp without a non-empty base_url
pot = ea.get('youtubepot-bgutilhttp')
if isinstance(pot, dict):
    if not normalize_pot_url(str(pot.get('base_url') or '')):
        ea.pop('youtubepot-bgutilhttp', None)

if ea:
    opts['extractor_args'] = ea
else:
    opts.pop('extractor_args', None)

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

if [ -n "${bgutil-ytdlp-pot-provider.railway.internal:-}" ]; then
  echo "metube-entrypoint: bgutil-ytdlp-pot-provider.railway.internal is set (POT enabled)"
else
  echo "metube-entrypoint: bgutil-ytdlp-pot-provider.railway.internal is empty — POT disabled; ensure Railway YTDL_OPTIONS has no empty youtubepot-bgutilhttp"
fi

cd /app
exec /usr/bin/tini -g -- /app/docker-entrypoint.sh
