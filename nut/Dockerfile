ARG BUILD_FROM=hassioaddons/base:7.2.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Copy root filesystem
COPY rootfs /

# Setup base
RUN \
    apk add --no-cache \
        hwids@edge=20191025-r0 \
        usbutils@edge=012-r1 \
        nut@edge=2.7.4-r6 \
    \
    && rm -f -r \
        /etc/nut/*.apk-new

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Network UPS Tools" \
    io.hass.description="Manage battery backup (UPS) devices" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Dale Higgs <dale3h@addons.community>" \
    org.opencontainers.image.title="Network UPS Tools" \
    org.opencontainers.image.description="Manage battery backup (UPS) devices" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Dale Higgs <dale3h@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-nut" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-nut/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
