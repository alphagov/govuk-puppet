# == Class: govuk_search::docker
#
# Installs and configures Docker and Docker Compose
class govuk_search::docker_elasticsearch {

  file { '/usr/share/docker':
    ensure => directory,
  } ->

  file { '/usr/share/docker/elasticsearch-docker-compose.yml':
    ensure  => file,
    content => template('govuk_search/elasticsearch-docker-compose.yml'),
  }

  include ::govuk_docker

  class { '::docker::compose':
    ensure  => present,
    version => '1.7.0',
  }

  docker_compose { '/usr/share/docker/elasticsearch-docker-compose.yml':
    ensure  => present,
    require => File['/usr/share/docker/elasticsearch-docker-compose.yml'],
  }

}
