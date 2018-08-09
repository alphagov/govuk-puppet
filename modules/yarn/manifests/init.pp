# == Class: yarn
#
# Installs yarn, javascript package management tool: https://yarnpkg.com/en/
#
# === Parameters:
#
# [*version*]
#   Version to install. Defaults to 'present' which will install latest version
#
class yarn(
  $version = 'present',
) {

  class { '::yarn::repo': }

  package { 'yarn':
    ensure  => $version,
    require => Class['Yarn::Repo'],
  }
}
