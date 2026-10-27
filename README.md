# Yamtrack – Home Assistant add-on

Runs [Yamtrack](https://github.com/FuzzyGrim/Yamtrack) on HAOS / Supervised installs.
Wraps the official image (pinned version) and bundles the Redis it needs.

## Install

1. In Home Assistant: **Settings → Add-ons (Apps) → Add-on Store → ⋮ → Repositories**
2. Add `https://github.com/Taylock2/ha-addon-yamtrack`.
3. Install **Yamtrack**, set the `urls` option (and pick a free port on the Network tab if
   `8000` is taken), start it.
4. Open `http://<HA-IP>:<port>/` and use **Sign up** to create your account, then turn
   `registration` off.

See the add-on's Documentation tab for reverse proxy (Nginx Proxy Manager), sidebar
and calendar setup.

## Status

Early. Works on a HAOS + Nginx Proxy Manager subpath setup. Not affiliated with the
Yamtrack project.
