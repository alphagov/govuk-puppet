# == Class: govuk_ci::agent::docker
#
# Installs and configures Docker and Docker Compose
class govuk_ci::agent::docker {

  # Jenkins user needs to be able to build and manage containers
  class { '::docker':
    docker_users => ['jenkins'],
  }

  include ::docker::compose

}
