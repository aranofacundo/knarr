FROM ubuntu:focal

LABEL maintainer="aranofacundo@berserker.com.ar" \
    version="1.2.0"

ENV DEBIAN_FRONTEND=noninteractive

ENV PUID="1000"
ENV PGID="1000"

ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_VERSION=2.0.0.1
ARG S6_OVERLAY_FILE=s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_FILE}

RUN knarr_upgrade \
    && knarr_install nginx curl bash cron ca-certificates tzdata

RUN curl -L ${S6_OVERLAY_URL} -o /tmp/${S6_OVERLAY_FILE} \
    && tar xzf /tmp/${S6_OVERLAY_FILE} -C / --exclude="./bin" \
    && tar xzf /tmp/${S6_OVERLAY_FILE} -C /usr ./bin \
    && rm -rf /tmp/*

RUN groupadd -g ${PGID} knarr && \
    useradd -u ${PUID} -d /dev/null -s /sbin/nologin -g knarr knarr

COPY rootfs /

EXPOSE 80
ENTRYPOINT ["/init", "/tmp"]
