FROM debian:buster

LABEL maintainer="aranofacundo@berserker.com.ar" \
    version="0.1.3"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_VERSION=1.22.1.0
ARG S6_OVERLAY_FILE=s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_FILE}

ADD ${S6_OVERLAY_URL} /tmp/
RUN tar xzf /tmp/${S6_OVERLAY_FILE} -C /

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get install --no-install-recommends -qy python3 python3-pip nginx curl \
    && apt-get install --no-install-recommends -qy build-essential python3-dev libpq-dev default-libmysqlclient-dev gettext \
    && apt-get autoremove --purge -qy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./services/nginx /etc/services.d/nginx/run

RUN pip3 install pipx && pipx ensurepath && pipx install poetry
ENV PATH="/root/.local/bin:${PATH}"

USER 1000
EXPOSE 80
ENTRYPOINT ["/init"]
