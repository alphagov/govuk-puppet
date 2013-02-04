class collectd::server {
  include ::collectd

  class { 'collectd::server::config':
    notify  => Class['collectd'],
  }

  class { 'collectd::server::firewall':
    require => Class['collectd::server::config'],
  }
}
