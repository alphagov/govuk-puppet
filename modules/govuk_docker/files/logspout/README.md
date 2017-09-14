## Intro

This Dockerfile creates a [logspout-logstash](https://github.com/looplab/logspout-logstash) container for use with [logit.io](logit.io).

[Logspout](https://github.com/gliderlabs/logspout) is a log router that uses a variety of adaptors to ship logs from docker containers. This one ships json logs to logstash.

This only provides support for TCP (with TLS), UDP cannot be used.

## Usage

This container can be run using:
```bash
docker run \
  --name="logit" \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  govuk/logspout-alpine \
  logstash+tls://<your-logit.io-endpoint>:<your-tcp-ssl-port>
```

Where:

* `logstash+tls` indicates the adapter to use (for insecure logging use `logstash+tcp`)
* `your-logit.io-endpoint` will be something like `th1s1snt-r3al-soit-aint-w0rth7rying1-yo.logit.io` (and can be found by going to your dashboard>stack settings>logstash)
* `your-tcp-ssl-port` is the port listed on the same page as the endpoint in the `input` block.

## Additional settings

Both the core [logship](https://github.com/gliderlabs/logspout#environment-variables) and [logstash adapter](https://github.com/looplab/logspout-logstash#available-configuration-options) take environment variables to configure them. This is an (incomplete) list of some of the relevant options:

* ALLOW_TTY - include logs from containers started with -t or --tty (i.e. * Allocate a pseudo-TTY)
* BACKLOG - suppress container tail backlog
* DEBUG - emit debug logs
* EXCLUDE_LABEL - exclude logs with a given label
* INACTIVITY_TIMEOUT - detect hang in Docker API (default 0)
* LOGSTASH_TAGS - Set of tags to apply to the log entry (e.g. "production, docker")
* LOGSTASH_FIELDS - a map of `key=value` pairs to add to the entry.
* DOCKER_LABELS - include all container labels to the entry as fields (any non-empty string is considered true and sets this).

For example these could be used like:

```bash
docker run \
  --name="logit" \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  -e EXCLUDE_LABEL="testing" \          # Exclude containers labelled "testing"
  -e LOGSTASH_TAGS="app-foo,docker" \   # Set some tags
  -e LOGSTASH_FIELDS="json_logs=true" \ # Flag the logs as json formatted
  govuk/logspout-alpine \
  logstash+tls://<your-logit.io-endpoint>:<your-tcp-ssl-port>
```
