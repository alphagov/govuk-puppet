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

  class {'::redis':
    conf_maxmemory => $conf_maxmemory,
  }

}