# == Class: Govuk_mysql::Xtrabackup::Packages
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of an APT mirror
#
class govuk_mysql::xtrabackup::packages (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  package { 'xtrabackup':
    ensure  => present,
    require => Class[Mysql::Server],
  }

  package { 's3cmd':
    ensure   => 'present',
    provider => 'pip',
  }

  file { '/root/.s3cfg':
    ensure  => present,
    content => template('govuk_mysql/s3cfg.erb'),
    mode    => '0600',
  }

  apt::source { 'percona':
    location     => "http://${apt_mirror_hostname}/percona",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'qpress':
    ensure => present,
  }

  apt::source { 'gof3r':
    location     => "http://${apt_mirror_hostname}/gof3r",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'gof3r':
    ensure  => '0.5.0',
    require => Apt::Source['gof3r'],
  }
}
