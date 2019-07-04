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
    version => '1.22.0',
  }

  cron::crondotdee { 'docker_system_prune_dangling' :
    hour    => '*',
    minute  => 0,
    command => 'docker system prune -f --filter="until=1h"',
  }

  cron::crondotdee { 'docker_system_prune_all' :
    hour    => 4,
    minute  => 30,
    command => 'docker system prune -a -f --filter="until=48h"',
  }

  cron::crondotdee { 'docker_volume_prune' :
    hour    => '*',
    minute  => 5,
    command => 'docker volume prune -f',
  }
}
