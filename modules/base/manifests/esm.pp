# == Class: base::esm
#
# Installs extended security maintenance repo and credentials
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
  package { 'ubuntu-advantage-tools':
    ensure  => '10ubuntu0.14.04.3',
    require => Package['apt-transport-https'],
  }

  package { 'apt-transport-https':
    ensure  => present,
  }

  exec {'create esm repo':
    command => "sudo ubuntu-advantage enable-esm ${esm_user}:${esm_password}",
    require => Package['ubuntu-advantage-tools'],
  }
}
