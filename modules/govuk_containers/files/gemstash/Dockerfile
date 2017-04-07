FROM alpine:3.3
MAINTAINER  govuk-role-platform-accounts-members@digital.cabinet-office.gov.uk

RUN apk add --no-cache --virtual .ruby-builddeps \
        autoconf \
        bison \
        bzip2 \
        bzip2-dev \
        ca-certificates \
        coreutils \
        gcc \
        gdbm-dev \
        glib-dev \
        libc-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        ncurses-dev \
        make \
        openssl \
        openssl-dev \
        procps \
        readline-dev \
        ruby \
        tar \
        yaml-dev \
        zlib-dev \
        xz \
    &&\
    apk add --no-cache --virtual .ruby-rundeps \
        ruby \
        ruby-dev \
        sqlite-dev \
        curl \
    ruby-io-console \
    ruby-json \
    &&\
    gem install --no-ri --no-rdoc gemstash \
    &&\
    apk del .ruby-builddeps

EXPOSE 9292

HEALTHCHECK --interval=15s --timeout=3s \
  CMD curl -f http://localhost:9292/ || exit 1

CMD ["/usr/bin/gemstash", "start", "--no-daemonize"]
