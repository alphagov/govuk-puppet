# == Class: govuk_search::prune
#
# Delete all but the latest N Elasticsearch snapshots.  Used to keep
# the data sync S3 buckets small, as Elasticsearch can't automatically
# prune old snapshots.
#
# === Parameters
#
# [*es_repo*]
#   The Elasticsearch snapshot repository.
#
# [*es5_address*]
#   Hostname and port of the Elasticsearch 5 server.
#   Default: elasticsearch5:80
#
# [*es6_address*]
#   Hostname and port of the Elasticsearch 6 server.
#
# [*cron_hour*]
#   The hour at which the prune runs.
#   Default: 6
#
# [*cron_minute*]
#   The minute at which the prune runs.
#   Default: 0
#
# [*snapshots_to_keep*]
#   The number of snapshots to keep.
#   Default: 1
#
class govuk_search::prune (
  $es_repo = undef,
  $es5_address = 'elasticsearch5:80',
  $es6_address = undef,
  $cron_hour = 6,
  $cron_minute = 0,
  $snapshots_to_keep = 1,
){

  if $es_repo {
    if $es5_address {
      $es5_ensure = 'present'
    } else {
      $es5_ensure = 'absent'
    }
    if $es6_address {
      $es6_ensure = 'present'
    } else {
      $es6_ensure = 'absent'
    }

    ensure_packages(['jq'])
  } else {
    $es5_ensure = 'absent'
    $es6_ensure = 'absent'
  }

  file { '/usr/local/bin/es-prune-snapshots':
    ensure  => 'absent',
    content => template('govuk_search/es-prune-snapshots.erb'),
    mode    => '0755',
  }

  cron::crondotdee { 'es-prune-snapshots':
    ensure  => 'absent',
    command => '/usr/local/bin/es-prune-snapshots',
    hour    => $cron_hour,
    minute  => $cron_minute,
  }

  file { '/usr/local/bin/es5-prune-snapshots':
    ensure  => $es5_ensure,
    content => template('govuk_search/es5-prune-snapshots.erb'),
    mode    => '0755',
  }

  file { '/usr/local/bin/es6-prune-snapshots':
    ensure  => $es6_ensure,
    content => template('govuk_search/es6-prune-snapshots.erb'),
    mode    => '0755',
  }

  cron::crondotdee { 'es5-prune-snapshots':
    ensure  => $es5_ensure,
    command => '/usr/local/bin/es5-prune-snapshots',
    hour    => $cron_hour,
    minute  => $cron_minute,
  }

  cron::crondotdee { 'es6-prune-snapshots':
    ensure  => $es6_ensure,
    command => '/usr/local/bin/es6-prune-snapshots',
    hour    => $cron_hour,
    minute  => $cron_minute,
  }
}
