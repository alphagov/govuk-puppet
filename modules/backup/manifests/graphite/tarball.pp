# FIXME: Remove class when deployed.
class backup::graphite::tarball (
    $backup_directory  = '/opt/graphite/backup',
) {

  file { $backup_directory:
    ensure => absent,
    force  => true,
    backup => false,
  }

  file { '/usr/local/bin/graphite_tarball':
    ensure  => absent,
  }

  cron { 'graphite-nightly-tarball':
    ensure => absent,
    user   => 'root',
  }
}
