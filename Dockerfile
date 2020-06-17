FROM ubuntu:focal

LABEL maintainer="aranofacundo@berserker.com.ar" \
    version="1.1.2"

ENV DEBIAN_FRONTEND=noninteractive

ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_VERSION=2.0.0.1
ARG S6_OVERLAY_FILE=s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_FILE}

RUN apt-get update && apt-get upgrade -qy \
    && apt-get install --no-install-recommends -qy nginx curl bash cron ca-certificates \
    && apt-get autoremove --purge -qy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L ${S6_OVERLAY_URL} -o /tmp/${S6_OVERLAY_FILE} \
    && tar xzf /tmp/${S6_OVERLAY_FILE} -C / --exclude="./bin" \
    && tar xzf /tmp/${S6_OVERLAY_FILE} -C /usr ./bin \
    && rm -rf /tmp/*

COPY rootfs /

EXPOSE 80
ENTRYPOINT ["/init"]
