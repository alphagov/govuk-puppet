# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class collectd::server {
  include ::collectd

  class { 'collectd::server::config':
    notify  => Class['collectd::service'],
    require => Class['collectd::package'],
  }

  class { 'collectd::server::firewall':
    require => Class['collectd::server::config'],
  }
}
