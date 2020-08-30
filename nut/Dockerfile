ARG BUILD_FROM=hassioaddons/base:8.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        hwids=20200306-r0 \
        libtool=2.4.6-r7 \
        libusb-compat=0.1.5-r4 \
        neon=0.31.1-r0 \
        net-snmp-libs=5.8-r3 \
        openssl=1.1.1g-r0 \
        usbutils=012-r1 \
    && apk add --no-cache --virtual .build-dependencies \
        autoconf=2.69-r2 \
        automake=1.16.2-r0 \
        build-base=0.5-r2 \
        libusb-compat-dev=0.1.5-r4 \
        neon-dev=0.31.1-r0 \
        net-snmp-dev=5.8-r3 \
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
