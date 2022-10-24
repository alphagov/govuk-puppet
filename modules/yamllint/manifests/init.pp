# == Class: yamllint
#
# Installs yamlliv, a linter for YAML files: https://yamllint.readthedocs.io/en/stable/
#
# === Parameters:
#
# [*version*]
#   Version to install. Defaults to '1.28.0'
#
class yamllint(
  $version = '1.28.0',
) {

  class { '::yamllint::repo': }

  package { 'yamllint':
    ensure  => $version,
    require => Class['Yamllint::Repo'],
  }
}
