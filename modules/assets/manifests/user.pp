# == Class: assets::user
#
# Configures the 'assets' user and group.
#
class assets::user {
  include assets::group

  $home = '/home/assets'
  $user = 'assets'

  user { $user:
    ensure  => 'present',
    home    => $home,
    shell   => '/bin/bash',
    uid     => '2900',
    gid     => 'assets',
    require => [Group['assets']],
  } ->
  file { $home:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0750',
  }
}
