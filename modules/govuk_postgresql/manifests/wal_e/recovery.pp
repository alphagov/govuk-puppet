# == Class: Govuk_postgresql::Wal_e::Recovery
#
# Creates prerequisites to restore data.
#
class govuk_postgresql::wal_e::recovery {
  $datadir = $postgresql::globals::datadir,

  file { "${datadir}/recovery.conf":
    ensure  => present,
    content => 'restore_command = \'envdir /etc/wal-e/env.d /usr/local/bin/wal-e wal-fetch "%f" "%p"\'',
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0644',
  }
}
