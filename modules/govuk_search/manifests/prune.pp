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
# [*es_address*]
#   Hostname and port of the Elasticsearch server.
#   Default: elasticsearch5:80
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
  $es_address = 'elasticsearch5:80',
  $cron_hour = 6,
  $cron_minute = 0,
  $snapshots_to_keep = 1,
){

  if $es_repo {
    $ensure = 'present'
    ensure_packages(['jq'])
  } else {
    $ensure = 'absent'
  }

  file { '/usr/local/bin/es-prune-snapshots':
    ensure  => $ensure,
    content => template('govuk_search/es-prune-snapshots.erb'),
    mode    => '0755',
  }

  cron::crondotdee { 'es-prune-snapshots':
    ensure  => $ensure,
    command => '/usr/local/bin/es-prune-snapshots',
    hour    => $cron_hour,
    minute  => $cron_minute,
  }
}
