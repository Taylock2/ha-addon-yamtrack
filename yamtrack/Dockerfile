# Wraps the official Yamtrack image and bundles Redis (required by Yamtrack),
# so it fits the one-container model of Home Assistant add-ons.
FROM ghcr.io/fuzzygrim/yamtrack:0.26.3

RUN apk add --no-cache redis jq

# Upstream sends X-Frame-Options twice (Django: DENY, its nginx: SAMEORIGIN);
# browsers treat the conflict as DENY, which blocks HA Webpage dashboards.
# Drop Django's copy so only SAMEORIGIN remains.
RUN for f in /etc/nginx/nginx.conf /etc/nginx/nginx.ipv6.conf; do \
        sed -i 's#proxy_pass http://app_server;#&\n            proxy_hide_header X-Frame-Options;#' "$f" \
        && grep -q 'proxy_hide_header X-Frame-Options' "$f"; \
    done

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
