# == Class: assets::user
#
# Configures the 'assets' user and group.
#
class assets::user {
  $home = '/home/assets'
  $user = 'assets'

  user { $user:
    ensure => absent,
    uid    => '2900',
  }

  group { 'assets':
    ensure => absent,
    gid    => '2900',
  }

  file { $home:
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }
}
