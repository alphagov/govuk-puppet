# == Class: mongodb::configure_replica_set
#
# Configures a MongoDB replica set
#
# === Parameters:
#
# [*members*]
#   A hash of members to add to the replica set.
#
# [*replicaset_name*]
#   A string for the name of the replica set.
#   Passed in by `mongodb::server` which sets it to
#   'production' unless $development is true, in which
#   case it is set to 'development'.
#
class mongodb::configure_replica_set (
  $members,
  $replicaset_name,
) {
  validate_hash($members)

  file { '/etc/mongodb':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  $members_hostnames = keys($members)

  file { '/etc/mongodb/configure-replica-set.js':
    ensure  => present,
    content => template('mongodb/configure-replica-set.js'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['mongodb::config'],
  }

  exec { 'configure-replica-set':
    command => "/usr/bin/mongo --quiet --host ${members_hostnames[0]} /etc/mongodb/configure-replica-set.js",
    unless  => "/usr/bin/mongo --host ${members_hostnames[0]} --quiet --eval 'rs.status().ok' | grep -q 1",
    require => [
      File['/etc/mongodb/configure-replica-set.js'],
      Class['mongodb::service'],
    ],
  }
}
