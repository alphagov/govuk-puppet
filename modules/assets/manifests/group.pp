# == Class: assets::group
#
# Configures the 'assets' group.
#
class assets::group {
  group { 'assets':
    ensure => 'present',
    gid    => '2900',
  }
}
