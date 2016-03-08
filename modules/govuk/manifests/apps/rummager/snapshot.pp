# == Class: govuk::apps::rummager::snapshot
#
# Run a script every 5 minutes to create repository (idempotent)
# and take a search index snapshot.
#
# === Parameters
#
# [*snapshot_enable*]
#   Whether to enable the cron job that takes search index snapshot
#   Default: false
#
# [*snapshot_user*]
#   User that runs the cron job
#   Default: deploy
#
# [*snapshot_service_desc*]
#   Service name to report to icinga
#   Default: rummager-snapshot
#

class govuk::apps::rummager::snapshot (
  $snapshot_enable = false,
  $snapshot_user = 'deploy',
  $snapshot_service_desc = 'rummager-snapshot',
  $pruning_service_desc = 'rummager-pruning',
) {

  $snapshot_ensure = $snapshot_enable ? {
    true    => present,
    default => absent,
  }

  file { '/etc/cron.d/snapshot':
    ensure  => $snapshot_ensure,
    mode    => '0755',
    content => template('govuk/etc/cron.d/snapshot.erb'),
  }

  file { '/usr/local/bin/rummager-snapshot':
    ensure  => $snapshot_ensure,
    mode    => '0755',
    content => template('govuk/usr/local/bin/rummager-snapshot.erb'),
  }

  $threshold_secs = 15 * 60

  if $snapshot_enable {
    @@icinga::passive_check { "check_rummager_snapshot_${::hostname}":
      service_description => $snapshot_service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
  }
}
