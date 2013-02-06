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
