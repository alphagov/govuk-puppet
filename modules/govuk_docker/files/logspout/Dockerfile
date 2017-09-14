FROM gliderlabs/logspout
LABEL maintainer="govuk-role-platform-accounts-members@digital.cabinet-office.gov.uk" \
      description="Run a logspout-logstash container shipping to Logit.io" \
      version="0.1.0"

# The real magic happens in ./build.sh and ./modules.go, which are pulled
# in by gliderlabs/logspout which has some ONBUILD COPY lines to
# consume them
