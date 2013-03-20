# == Class: ganglia::remove
#
# Remove Ganglia client and server from existing nodes.
#
# We don't use sysv or upstart providers for the services because we're
# removing the scripts in the same run. This will prevent the resources from
# failing on subsequent runs.
#
# FIXME: This is transitionary. It can be removed once applied to all
# environments.
#
class ganglia::remove {
  $service_names = ['gmetad', 'ganglia-monitor']
  $package_names = flatten(['libganglia1', $service_names])

  service {
    'gmetad':
      ensure    => stopped,
      pattern   => '/usr/sbin/gmetad',
      stop      => '/sbin/stop gmetad',
      provider  => 'base';
    'ganglia-monitor':
      ensure    => stopped,
      pattern   => '/usr/sbin/gmond',
      provider  => 'base';
  }

  package { $package_names:
    ensure  => purged,
    require => Service[$service_names],
  }

  file { [
    '/etc/init/gmetad.conf',
    '/etc/ganglia',
    '/usr/lib/ganglia',
    '/var/lib/ganglia',
    '/var/www/ganglia-web-3.5.0'
  ]:
    ensure  => absent,
    purge   => true,
    force   => true,
    recurse => true,
    backup  => false,
    require => Package[$package_names],
  }
}
