# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::server::config inherits collectd::config {
  File['/etc/collectd/conf.d/network.conf'] {
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/network.conf.server',
  }

  file { '/etc/collectd/conf.d/graphite.conf':
    ensure => present,
    source => 'puppet:///modules/collectd/etc/collectd/conf.d/graphite.conf',
  }
}
