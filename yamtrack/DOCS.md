# Yamtrack

Self-hosted media tracker. Add the shows you watch and use the calendar for upcoming episodes.

## First start

1. On the **Network** tab, pick a free host port (default `8000`).
2. Set `urls` (and `base_url` if you use a reverse proxy, see below), then start the add-on.
3. Open Yamtrack and use **Sign up** to create your account - there is no default user.
4. Turn `registration` off and restart, so nobody else can sign up.

The add-on has no "Open Web UI" button: it can only point at `host:port`, which is
wrong once Yamtrack sits behind a proxy subpath. Use a sidebar link instead (see below).

## Options

| Option | Notes |
|---|---|
| `urls` | **Set this.** Every address you open Yamtrack at, comma separated, e.g. `http://192.168.1.50:8000,https://example.com`. Origins only - any path or trailing slash is stripped. Logins fail with a CSRF error if the address in your browser isn't listed. |
| `timezone` | IANA name, e.g. `Australia/Melbourne` or `Europe/London`. |
| `secret` | Optional. Left empty, a random key is generated once and kept. |
| `tmdb_api_key` | Optional. Yamtrack has a built-in default; use your own free TMDB key if you hit rate limits. |
| `registration` | Turn off after you've created your account. |
| `base_url` | Optional. Subpath when served behind a reverse proxy, e.g. `/yamtrack`. The proxy must strip the prefix before forwarding. Once set, browse via the proxy only (links and login cookies use the subpath). |

## Behind Nginx Proxy Manager on a subpath

1. Set `base_url` to `/yamtrack` and add your public origin (no path) to `urls`,
   e.g. `http://192.168.1.50:8000,https://example.com`. Restart the add-on.
2. On your existing proxy host, add a **Custom Location**:
   - Location: `/yamtrack/`
   - Scheme: `http`
   - Forward Hostname / IP: `<HA-IP>/` - keep the trailing slash, it strips the prefix
   - Forward Port: the add-on's host port
   - Advanced (gear icon):
     ```nginx
     proxy_set_header Host $host;
     proxy_set_header X-Real-IP $remote_addr;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header X-Forwarded-Proto $scheme;
     ```
3. Open `https://example.com/yamtrack/` (with the trailing slash).

A dedicated subdomain (e.g. `https://yamtrack.example.com` as its own proxy host) also
works and needs no `base_url`.

## Sidebar link in Home Assistant

**Settings → Dashboards → Add Dashboard → Webpage**, URL `https://example.com/yamtrack/`.
Embedding is only allowed from the same origin, so this works when Home Assistant itself
is opened at `https://example.com`, not via its LAN IP.

## Home Assistant calendar

1. In Yamtrack, open **Calendar** and copy the **Export link** at the bottom. It contains
   a private token - treat it like a password (it can be regenerated in Yamtrack).
2. In Home Assistant: **Settings → Devices & services → Add integration → Remote Calendar**
   and paste the link.

If Home Assistant can't reach your public address from inside the LAN, use the direct
port instead and **drop the `base_url` prefix**, e.g.
`http://192.168.1.50:8000/calendar/download/<token>`.

The feed covers the past 30 and next 90 days, for items you're tracking.

## Troubleshooting

- **"Using a Reverse Proxy?" / CSRF error on login** - check `urls` matches the browser's
  address exactly (scheme, host, port). If it does, a stale `csrftoken` cookie from before
  `base_url` was set is the usual cause: delete that cookie for the site, or try a private
  window.
- **Redirected to `/accounts/login/` without the subpath** - `base_url` isn't set or the
  add-on wasn't restarted.

## Data

The SQLite database lives in the add-on's `/data` and is included in HA backups.
**Uninstalling the add-on deletes it** - take a backup first.
