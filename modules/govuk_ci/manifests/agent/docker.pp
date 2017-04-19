# == Class: govuk_ci::agent::docker
#
# Installs and configures Docker and Docker Compose
class govuk_ci::agent::docker {

  # Mount docker on it's own disk
  Govuk_mount['/var/lib/docker'] ->

  # Jenkins user needs to be able to build and manage containers
  class { '::govuk_docker':
    docker_users => ['jenkins'],
  }

  include ::docker::compose

}
