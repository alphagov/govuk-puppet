# == Class: nodejs
#
# installs nodejs
#
# === Parameters:
#
# [*version*]
#   Version to install.  Leave `undef` to install any version that's available
#   Default: `undef`
#
class nodejs(
  $version = 'present',
) {

  class { '::nodejs::repo': }

  package { 'nodejs':
    ensure  => $version,
    require => Class['Nodejs::Repo'],
  }
}
