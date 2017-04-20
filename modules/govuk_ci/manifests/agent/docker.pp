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

  cron::crondotdee { 'remove_docker_dangling_images' :
    hour    => 10,
    minute  => 0,
    command => 'docker rmi $(docker images --filter "dangling=true" -q --no-trunc)',
  }

  cron::crondotdee { 'remove_docker_dangling_volumes' :
    hour    => 10,
    minute  => 2,
    command => 'docker volume rm $(docker volume ls -qf dangling=true)',
  }
}
