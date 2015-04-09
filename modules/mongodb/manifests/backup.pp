# == Class: mongodb::backup
#
# Backup MongoDB databases using automongodbbackup
#
# === Parameters:
#
# [*enabled*]
#   Whether mongodb backups should be enabled or disabled
#
# [*domonthly*]
#   Whether monthly backups should be enabled or disabled
#
class mongodb::backup(
  $enabled = true,
  $domonthly = true
) {
  $threshold_secs = 28 * 3600
  $service_desc = 'AutoMongoDB backup'

  if $enabled {
    include logrotate

    file { '/etc/cron.daily/automongodbbackup-replicaset':
      ensure  => present,
      content => template('mongodb/automongodbbackup'),
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      require => Class['mongodb::package'],
    } ->
    file { '/var/log/automongodbbackup':
      ensure => directory,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
    }

    govuk::logstream { 'automongodbbackup':
      ensure  => present,
      fields  => {'application' => 'automongodbbackup'},
      logfile => '/var/log/automongodbbackup/backup.log',
      tags    => ['backup', 'automongodbbackup', 'mongo'],
    }

    file { '/etc/logrotate.d/automongodbbackup':
      ensure  => present,
      source  => 'puppet:///modules/mongodb/etc/logrotate.d/automongodbbackup',
      require => Class['logrotate'],
    }

    @@icinga::passive_check { "check_automongodbbackup-${::hostname}":
      service_description => $service_desc,
      freshness_threshold => $threshold_secs,
      host_name           => $::fqdn,
    }
  }

}
