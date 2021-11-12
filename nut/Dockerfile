ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:5.2.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM} as builder

# Setup builder
# hadolint ignore=DL3003
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       python \
       autoconf \
       automake \
       libtool \
       libneon27-dev \
       libsnmp-dev \
       libusb-dev \
       libltdl-dev

RUN git clone https://github.com/networkupstools/nut.git \
    && cd nut \
    && ./autogen.sh \
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
            --with-statepath=/var/run \
            --with-altpidpath=/var/run \
    && make DESTDIR=/app install \
    && make DESTDIR=/app install-conf

FROM ${BUILD_FROM}
# Setup base
# hadolint ignore=DL3003
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends\
       usbutils \
       libtool \
       libneon27-gnutls \
       libfreeipmi17 \
       openssl \
       libipmimonitoring6 \
       libsnmp-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy root filesystem
COPY rootfs /

# Copy nut files from builder
COPY --from=builder /app /

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
