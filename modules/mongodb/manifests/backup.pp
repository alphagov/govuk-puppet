# == Class: mongodb::backup
#
# Backup MongoDB databases using automongodbbackup
#
# === Parameters:
#
# [*replicaset_members*]
#   An array of members of the MongoDB replicaset to be backed up
#
# [*enabled*]
#   Whether mongodb backups should be enabled or disabled
#
# [*domonthly*]
#   Whether monthly backups should be enabled or disabled
#
# [*s3_backups*]
#   Whether S3 backups should be enabled or disabled

class mongodb::backup(
  $replicaset_members,
  $enabled = true,
  $domonthly = true,
  $s3_backups = false,
) {
  $threshold_secs = 28 * 3600
  $service_desc = 'AutoMongoDB backup'

  # Sanity-check that replicaset members are defined using hostnames
  unless $::hostname in $replicaset_members {
    $replicaset_members_string = join($replicaset_members, ', ')
    fail("This machine\'s hostname was not found in the list of MongoDB replicaset members: ${replicaset_members_string}")
  }

  # Backups only needs to run on one member of the replicaset, since the data
  # is the same on each node
  if $::hostname == $replicaset_members[0] {
    $enabled_real = $enabled
  } else {
    $enabled_real = false
  }

  if $enabled_real {
    $present = 'present'
  } else {
    $present = 'absent'
  }

  file { '/etc/cron.daily/automongodbbackup-replicaset':
    ensure  => $present,
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

  govuk_logging::logstream { 'automongodbbackup':
    ensure  => $present,
    fields  => {'application' => 'automongodbbackup'},
    logfile => '/var/log/automongodbbackup/backup.log',
    tags    => ['backup', 'automongodbbackup', 'mongo'],
  }

  @logrotate::conf { 'automongodbbackup':
    ensure        => $present,
    matches       => '/var/log/automongodbbackup/backup.log',
    days_to_keep  => '31',
    delaycompress => true,
    copytruncate  => false,
    create        => '644 root root',
  }

  if $s3_backups and $enabled_real {
    include mongodb::s3backup::backup
    include mongodb::s3backup::package
  }
  
  if $enabled_real {
    include logrotate

    @@icinga::passive_check { "check_automongodbbackup-${::hostname}":
      service_description => $service_desc,
      freshness_threshold => $threshold_secs,
      host_name           => $::fqdn,
    }
  }

}
