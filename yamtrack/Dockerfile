# Wraps the official Yamtrack image and bundles Redis (required by Yamtrack),
# so it fits the one-container model of Home Assistant add-ons.
FROM ghcr.io/fuzzygrim/yamtrack:0.26.3

RUN apk add --no-cache redis jq

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
