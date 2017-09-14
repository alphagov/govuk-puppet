FROM gliderlabs/logspout
LABEL maintainer="govuk-role-platform-accounts-members@digital.cabinet-office.gov.uk" \
      description="Run a logspout-logstash container shipping to Logit.io" \
      version="0.1.0"

RUN apk update \
  && apk add -U --virtual \
    build-dependencies \
    ca-certificates \
    curl \
  && curl https://cdn.logit.io/logit-intermediate.crt -o /usr/local/share/ca-certificates/logit-intermediate.crt \
  && update-ca-certificates \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*
