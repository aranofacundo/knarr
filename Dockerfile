FROM python:3.7

LABEL maintainer="aranofacundo@berserker.com.ar" \
    version="0.1.8"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/root/.local/bin:/usr/local/bin:${PATH}"

ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_VERSION=1.22.1.0
ARG S6_OVERLAY_FILE=s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_FILE}

ADD ${S6_OVERLAY_URL} /tmp/
RUN tar xzf /tmp/${S6_OVERLAY_FILE} -C /

RUN apt-get update \
    && apt-get install --no-install-recommends -qy nginx curl default-libmysqlclient-dev gettext \
    && apt-get autoremove --purge -qy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./services/99-nginx /etc/services.d/99-nginx/run

RUN pip3 install pipx && pipx ensurepath && pipx install poetry

EXPOSE 80
ENTRYPOINT ["/init"]
