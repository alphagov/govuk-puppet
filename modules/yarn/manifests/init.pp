# == Class: yarn
#
# Installs yarn, javascript package management tool: https://yarnpkg.com/en/
#
# === Parameters:
#
# [*version*]
#   Version to install. Defaults to '1.22.4-1'
#
class yarn(
  $version = '1.22.4-1',
) {

  class { '::yarn::repo': }

  package { 'yarn':
    ensure  => $version,
    require => Class['Yarn::Repo'],
  }
}
