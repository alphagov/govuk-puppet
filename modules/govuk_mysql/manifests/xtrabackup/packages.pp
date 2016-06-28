# == Class: Govuk_mysql::Xtrabackup::Packages
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
class govuk_mysql::xtrabackup::packages (
  $apt_mirror_hostname  = '',
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

  package { 'qpress':
    ensure => present,
  }

  apt::source { 'gof3r':
    location     => "http://${apt_mirror_hostname}/gof3r",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'gof3r':
    ensure  => '0.5.0',
    require => Apt::Source['gof3r'],
  }
}
