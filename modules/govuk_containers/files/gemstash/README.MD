## Intro

This Dockerfile creates a [Gemstash](https://github.com/bundler/gemstash) server running on [Alpine Linux](https://github.com/bundler/gemstash).

## Usage

To run the container so that it is accessible from outside & persisted to disk use:
```bash
$ docker run --name=<some name> --net=host -P -v <some-directory>:/root/.gemstash govuk/gemstash-alpine
```

where the flags have the following meanings:

* `--name` set a friendly (non-random) name
* `--net` use the host's network interface (rather than the docker bridge)
* `-P` allow access to the container from outside of docker
* `-v` map `<some-directory>` on the host to `/root/.gemstash` inside the container (so that the cache persists if the container stops).

### Configuring Bundler

Gemstash is a caching proxy for Ruby gems and should be used with [Bundler](https://bundler.io/). To configure Bundler to use the cache run:
```bash
$ bundle config mirror.https://rubygems.org http://<docker host>:9292
```

## Building

To create the docker image run:
```bash
$ docker build .
```

## Health-check

The docker container has a health-check (`curl -f http://localhost:9292 || exit 1`) which will flag the container as unhealthy if curl (when run inside the container) gets a 5xx response. You can query this health-check in a number of ways:
```bash
$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                    PORTS               NAMES
86b133245e54        25897c36b312        "/usr/bin/gemstash..."   28 minutes ago      Up 28 minutes (healthy)                       gemstash
```
will append the health-check response to the 'STATUS' column. To extract just the health you can use `inspect` and a parsing tool like [jq](https://stedolan.github.io/jq/):
```bash
$ sudo docker inspect gemstash | jq '.[].State.Health.Status'
"healthy"
```

