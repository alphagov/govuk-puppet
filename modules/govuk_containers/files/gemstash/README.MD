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
will append the health-check response to the 'STATUS' column. To extract just the health you can use `inspect`:
```bash
$ sudo docker inspect --format='{{json .State.Health.Status}}' gemstash
"healthy"
```


## Setting up Auto-build

<!-- FIXME: this should be moved but we don't currently have a better location -->
This image is automatically built on [Docker Hub](hub.docker.com). This is done using their [Automated Build process](https://docs.docker.com/docker-hub/builds/#create-an-automated-build).

You'll need a Docker Hub account, to be part of the [GOV.UK](https://hub.docker.com/u/govuk/) organization and to have linked your github account using the recommended 'Public and Private' method.

The main steps are:

1. Click 'Create' (top right corner) then 'Create Automated Build'
2. Click 'Create Auto-build Github' (the next page may take some time to load)
3. Select the repository that contains the DockerFile (for example 'govuk-puppet')
4. Set the namespace, name, visibility and a description:
    * Namespace: `govuk`
    * Name: what ever you like (this uses `gemstash-alpine`)
        - The name and namespace determine the path used to pull the image created, in this case it's `govuk/gemstash-alpine`
        - You can have multiple DockerFiles in a repository by differentiating them by namespace/name and location
    * Visibility: whether the image is public or private.
5. You then should click the 'Click here to customize' link.
    * This will allow you to configure build tags and triggers.
    * By default the master branch is built and tagged 'latest'
6. You should specify where in the repository the DockerFile is in the "DockerFile Location" field.
    * *Remember*: you should only have one DockerFile per directory (and everything in that directory is passed to the build process unless explicitly [ignored](https://docs.docker.com/engine/reference/builder/#dockerignore-file))
7. Set up any further build properties. For example how to name other branch or tag builds.
8. Click 'Create'

