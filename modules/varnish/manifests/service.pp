# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
