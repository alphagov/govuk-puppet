# == Class: base::esm
#
# Installs extended security maintenance credentials and preferences
#
# === Parameters
#
# [*esm_user*]
#   username for ESM repo.
#
# [*esm_password*]
#   password for ESM repo.
#
class base::esm (
  $esm_user,
  $esm_password,
) {
  file { '/etc/apt/auth.conf.d/90ubuntu-advantage':
    ensure  => file,
    content => template('base/90ubuntu-advantage.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
  file { '/etc/apt/apt.conf.d/51ubuntu-advantage-esm':
    ensure => file,
    source => 'puppet:///modules/base/51ubuntu-advantage-esm',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  package { 'apt-transport-https':
    ensure  => present,
  }
}
