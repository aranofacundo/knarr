FROM ubuntu:focal

LABEL maintainer="aranofacundo@berserker.com.ar" \
    version="1.3.0"

ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_VERSION=2.1.0.2
# ARG S6_OVERLAY_FILE=s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
# ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_FILE}
ARG S6_OVERLAY_INSTALLER_FILE=s6-overlay-${S6_OVERLAY_ARCH}-installer
ARG S6_OVERLAY_INSTALLER_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_INSTALLER_FILE}

ENV DEBIAN_FRONTEND=noninteractive

ENV PUID=1000
ENV PGID=1000
ENV CRON=0

COPY rootfs/usr/bin /usr/bin
RUN chmod 755 /usr/bin/knarr_install /usr/bin/knarr_upgrade

RUN knarr_upgrade \
    && knarr_install nginx curl bash cron ca-certificates tzdata nano

# S6-OVERLAY TAR FILE
# RUN curl -L ${S6_OVERLAY_URL} -o /tmp/${S6_OVERLAY_FILE} \
#     && tar xzf /tmp/${S6_OVERLAY_FILE} -C / --exclude="./bin" \
#     && tar xzf /tmp/${S6_OVERLAY_FILE} -C /usr ./bin \
#     && rm -rf /tmp/*

# S6-OVERLAY INSTALLER
RUN curl -L ${S6_OVERLAY_INSTALLER_URL} -o /tmp/${S6_OVERLAY_INSTALLER_FILE} \
    && chmod +x /tmp/${S6_OVERLAY_INSTALLER_FILE} \
    && /tmp/${S6_OVERLAY_INSTALLER_FILE} /

RUN groupadd -g ${PGID} knarr && \
    useradd -u ${PUID} -d /dev/null -s /sbin/nologin -g knarr knarr

COPY rootfs /
RUN chmod 755 /usr/bin/knarr_install /usr/bin/knarr_upgrade


VOLUME ["/tmp"]
EXPOSE 80
ENTRYPOINT ["/init"]
