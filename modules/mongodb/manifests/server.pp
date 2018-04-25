# == Class: mongodb::server
#
# Setup a MongoDB server.
#
# === Parameters:
#
# [*version*]
#   Version of mongodb. Should resolve to 2.6
#
# [*dbpath*]
#   Path to database on filesystem
#
# [*oplog_size*]
#   Defines size of the oplog in megabytes.
#   If undefined, we use MongoDB's default.
#
# [*replicaset_members*]
#   A hash of the members for the replica set.
#   Defaults to empty, which throws an error, so
#   it must be set.
#
# [*development*]
#   Disable journalling and backups and enable query profiling.
#   Saves space at the expense of data integrity.
#   Default: false
#
class mongodb::server (
  $version,
  $dbpath = '/var/lib/mongodb',
  $oplog_size = undef,
  $replicaset_members = {},
  $development = false,
) {

  if versioncmp($version, '3.0.0') >= 0 {
    $service_name = 'mongod'
    $package_name = 'mongodb-org'
    $config_filename = '/etc/mongod.conf'
    $template_name = 'mongod.conf.erb'
  } else {
    $service_name = 'mongodb'
    $package_name = 'mongodb-10gen'
    $config_filename = '/etc/mongodb.conf'
    $template_name = 'mongodb.conf'
  }

  validate_bool($development)
  validate_hash($replicaset_members)
  if empty($replicaset_members) {
    fail("Replica set can't have no members")
  }

  if $::aws_migration {
    include ::mongodb::aws_backup
  } else {
    unless $development {
      class { 'mongodb::backup':
        replicaset_members => keys($replicaset_members),
      }
    }
  }

  include govuk_unattended_reboot::mongodb
  include mongodb::repository

  if $development {
    $replicaset_name = 'development'
  } else {
    $replicaset_name = 'production'
  }

  anchor { 'mongodb::begin':
    before => Class['mongodb::repository'],
    notify => Class['mongodb::service'];
  }


  class { 'mongodb::package':
    version      => $version,
    package_name => $package_name,
    require      => Class['mongodb::repository'],
    notify       => Class['mongodb::service'];
  }

  # Some places we mount a separate disk for the mongodb
  # so need to ensure the owner of the directory is set
  file { "Ensure correct owner of ${dbpath}":
    path  => $dbpath,
    owner => 'mongodb',
    group => 'mongodb',
    mode  => '0755',
  }

  class { 'mongodb::config':
    config_filename => $config_filename,
    dbpath          => $dbpath,
    development     => $development,
    oplog_size      => $oplog_size,
    replicaset_name => $replicaset_name,
    template_name   => $template_name,
    require         => Class['mongodb::package'],
    notify          => Class['mongodb::service'];
  }

  class { 'mongodb::configure_replica_set':
    replicaset_name => $replicaset_name,
    members         => $replicaset_members,
    require         => Class['mongodb::service'];
  }

  class { 'mongodb::logging':
    require => Class['mongodb::config'],
  }

  class { 'mongodb::firewall':
    require => Class['mongodb::config'],
  }

  class { 'mongodb::service':
    service_name => $service_name,
    require      => Class['mongodb::logging'],
  }

  class { 'mongodb::monitoring':
    dbpath  => $dbpath,
    require => Class['mongodb::service'],
  }

  class { 'collectd::plugin::mongodb':
    require => Class['mongodb::config'],
  }

  # We don't need to wait for the monitoring class
  anchor { 'mongodb::end':
    require => Class[
      'mongodb::firewall',
      'mongodb::service',
      'mongodb::configure_replica_set'
    ],
  }

}
