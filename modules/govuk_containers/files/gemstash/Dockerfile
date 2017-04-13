FROM alpine:3.3
LABEL maintainer="govuk-role-platform-accounts-members@digital.cabinet-office.gov.uk" \
      description="Runs a Gemstash server on top of Alpine" \
      version="0.1.0"

RUN apk update \
    # Things we need in order to build ruby
    && apk add --no-cache --virtual .ruby-builddeps \
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
        make \
        ncurses-dev \
        openssl \
        openssl-dev \
        procps \
        readline-dev \
        ruby \
        tar \
        xz \
        yaml-dev \
        zlib-dev \
    # Things we need to run the container
    && apk add --no-cache --virtual .ruby-rundeps \
        curl \
        ruby \
        ruby-dev \
        sqlite-dev \
        ruby-io-console \
        ruby-json \
    # Get gemstash
    && gem install --no-ri --no-rdoc gemstash \
    # Clean up build dependencies
    && apk del .ruby-builddeps

EXPOSE 9292

HEALTHCHECK --interval=15s --timeout=3s\
        CMD curl -f http://localhost:9292/ || exit 1

CMD ["gemstash", "start", "--no-daemonize"]
