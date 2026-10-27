# Yamtrack

Self-hosted media tracker. Add the shows you watch and use the calendar for upcoming episodes.

## Options

| Option | Notes |
|---|---|
| `urls` | **Set this.** The address(es) you open Yamtrack at, comma separated, e.g. `http://homeassistant.local:8000,http://192.168.1.50:8000`. Needed or logins fail (CSRF). |
| `timezone` | e.g. `Europe/London`. |
| `secret` | Optional. Left empty, a random key is generated once and kept. |
| `tmdb_api_key` | Optional. Yamtrack has a built-in default; use your own free TMDB key if you hit rate limits. |
| `registration` | Turn off after you've created your account. |

## Home Assistant calendar

In Yamtrack, copy the calendar's iCalendar (.ics) URL, then in Home Assistant add it
with the **Remote Calendar** integration. Use `http://localhost:8000/...` style host
as reachable from HA (the add-on hostname is shown on the add-on's Info tab).

## Data

The SQLite database lives in the add-on's `/data` and is included in HA backups.
