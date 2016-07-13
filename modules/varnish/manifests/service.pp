# == Class: varnish::service
#
# Manage the varnish service
#
class varnish::service {

  service { 'varnish':
    ensure     => running,
    hasrestart => false,
    restart    => '/usr/sbin/service varnish reload',
  }

  # Sysv scripts always return exit code 0 on all dists.
  service { 'varnishncsa':
    ensure    => running,
    status    => '/etc/init.d/varnishncsa status | grep \'varnishncsa is running\'',
    hasstatus => false,
    require   => Service['varnish'],
  }
}
