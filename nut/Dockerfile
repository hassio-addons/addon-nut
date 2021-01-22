ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:9.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        hwids=20201207-r0 \
        libtool=2.4.6-r7 \
        libusb-compat=0.1.5-r4 \
        neon=0.31.2-r0 \
        net-snmp-libs=5.9-r1 \
        openssl=1.1.1i-r0 \
        usbutils=013-r0 \
    && apk add --no-cache --virtual .build-dependencies \
        autoconf=2.69-r3 \
        automake=1.16.3-r0 \
        build-base=0.5-r2 \
        libusb-compat-dev=0.1.5-r4 \
        neon-dev=0.31.2-r0 \
        net-snmp-dev=5.9-r1 \
    \
    && curl -J -L -o /tmp/nut.tar.gz \
        http://www.networkupstools.org/source/2.7/nut-2.7.4.tar.gz \
    && mkdir -p /tmp/nut \
    && tar zxf /tmp/nut.tar.gz -C \
        /tmp/nut --strip-components=1 \
    && cd /tmp/nut \
    && ./configure \
            --prefix=/usr \
            --libexecdir=/usr/lib/nut \
            --without-wrap \
            --with-user=root \
            --with-group=root \
            --disable-static \
            --with-serial \
            --with-usb \
            --without-avahi \
            --with-snmp \
            --with-neon \
            --without-powerman \
            --without-ipmi \
            --without-freeipmi \
            --with-libltdl \
            --without-cgi \
            --with-drvpath=/usr/lib/nut \
            --datadir=/usr/share/nut \
            --sysconfdir=/etc/nut \
            --with-statepath=/var/run/nut \
            --with-altpidpath=/var/run/nut \
    && make install \
    && apk del --no-cache --purge .build-dependencies \
    && rm -f -r \
        /tmp/* \
        /etc/nut/*.apk-new

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Dale Higgs <dale3h@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Dale Higgs <dale3h@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
