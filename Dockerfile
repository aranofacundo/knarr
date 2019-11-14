FROM python:3.7

LABEL maintainer="aranofacundo@berserker.com.ar" \
    version="0.1.5"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/root/.poetry/bin::${PATH}"

ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_VERSION=1.22.1.0
ARG S6_OVERLAY_FILE=s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_OVERLAY_FILE}

ADD ${S6_OVERLAY_URL} /tmp/
RUN tar xzf /tmp/${S6_OVERLAY_FILE} -C /

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get install --no-install-recommends -qy nginx curl default-libmysqlclient-dev gettext \
    && apt-get autoremove --purge -qy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./services/nginx /etc/services.d/99-nginx/run

RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3

EXPOSE 80
ENTRYPOINT ["/init"]
