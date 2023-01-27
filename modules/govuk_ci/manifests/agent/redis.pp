# == Class: govuk_ci::agent::redis
#
# Installs and configures redis-server
#
# === Parameters
#
# [*conf_maxmemory*]
#   Sets the config option "maxmemory" for redis
#
class govuk_ci::agent::redis(
  $conf_maxmemory = '256mb',
) {
  # Docker instances of Redis server versions that are installed in
  # parallel with the Ubuntu Trusty version
  include ::govuk_docker
  ::govuk_containers::ci_redis { 'ci-redis-6':
    version => '6',
    port    => 63796,
  }

  class {'::redis':
    conf_maxmemory => $conf_maxmemory,
  }

}
