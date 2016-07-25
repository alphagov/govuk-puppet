# == Class: loadbalancer::maintenance
#
# Sets up a machine so that the loadbalancer can be put
# into maintenance mode.
#
class loadbalancer::maintenance {
  file { '/usr/share/nginx/www':
    ensure  => directory,
    mode    => '0755',
    owner   => 'deploy',
    group   => 'deploy',
    require => Class['nginx::package'],
  }

  router::errorpage { 'scheduled_maintenance':
    require => File['/usr/share/nginx/www'],
  }
}
