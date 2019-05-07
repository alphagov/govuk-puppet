# == Class: govuk_search::docker
#
# Installs and configures Docker and Docker Compose
class govuk_search::docker_elasticsearch {

  file { '/usr/share/docker/elasticsearch-docker-compose.yml':
    ensure  => absent,
  }

  file { '/usr/share/docker/elasticsearch.yml':
    ensure  => absent,
  }

  docker_compose { '/usr/share/docker/elasticsearch-docker-compose.yml':
    ensure  => absent,
  }
}
