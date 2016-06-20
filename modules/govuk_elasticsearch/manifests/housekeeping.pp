# == Class: govuk_elasticsearch::housekeeping
#
#  Delete old snapshots from elasticsearch
#
#
# === Parameters:
#
# [*es_repos*]
#   The local elasticsearch repositories where snapshots are stored
#
# [*es_snapshot_limit*]
#   The number of snapshots we want to keep
#
# [*user*]
#   User that invokes backup
#
# === Variables
#
# [*$repositories*]
#   A string array of Elasticsearch repositories
#
class govuk_elasticsearch::housekeeping(
  $es_repos,
  $es_snapshot_limit = 5,
  $user = 'govuk-backup',
  ) {

  if $es_repos == undef {
    fail('No Elasticsearch repositories were set')
  } else {
    # Validates a maximum and minimum string length
    validate_slength($es_repos, 120, 3)
    $repositories = join(regsubst($es_repos,'(.*)','"\1"'), ' ')
  }

    # This is a CLI JSON processor which allows us to "awk" the data on the fly
    package { 'jq':
      ensure => installed,
    }

    file { 'es-prune-snapshots':
      ensure  => file,
      path    => '/usr/local/bin/es-prune-snapshots',
      content => template('govuk_elasticsearch/es-prune-snapshots.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }

    cron { 'elasticsearch-remove-old-snapshots':
      ensure  => present,
      command => '/usr/local/bin/es-prune-snapshots',
      user    => $user,
      weekday => 3,
      hour    => 4,
      minute  => 0,
    }
}
