# == Class: mongodb::config
#
# Configures a MongoDB server.
#
# === Parameters:
#
# [*dbpath*]
# [*logpath*]
# [*dbpath*]
#
# [*development*]
#   Disable journalling and enable query profiling.
#   Saves space at the expense of data integrity.
#   Default: false
#
# [*replicaset_name*]
#   A string for the name of the replicaset.
#   Passed in by `mongodb::server` which sets it to
#   'production' unless $development is true, in which
#   case it is set to 'development'.
#
class mongodb::config (
  $dbpath = '/var/lib/mongodb',
  $logpath,
  $development,
  $replicaset_name,
) {
  validate_bool($development)

  # Class params are used in the templates below.

  file { '/etc/mongodb.conf':
    ensure  => present,
    content => template('mongodb/mongodb.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/init/mongodb.conf':
    ensure  => present,
    content => template('mongodb/upstart-standalone.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
