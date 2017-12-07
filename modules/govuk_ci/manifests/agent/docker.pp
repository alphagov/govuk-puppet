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

  class { '::docker::compose':
    version => '1.17.1',
  }

  cron::crondotdee { 'docker_system_prune' :
    hour    => '*/2',
    minute  => 0,
    command => 'docker system prune -a -f --filter="until=24h"',
  }

  cron::crondotdee { 'docker_volume_prune' :
    hour    => '*/2',
    minute  => 5,
    command => 'docker volume prune -f',
  }
}
