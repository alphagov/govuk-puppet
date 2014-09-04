# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_redis_base {
  include govuk::node::s_base

  # FIXME: Reinstates default. Remove when deployed to production.
  file { '/etc/default/redis-server':
    ensure  => present,
    content => template('govuk/node/s_redis_base/etc/default/redis-server.erb'),
    notify  => Class['redis'],
  }

  $redis_port = 6379
  $redis_max_memory = $::memtotalmb / 4 * 3

  class { 'redis':
    # conf_dir is needed for compatibility with previous redis module
    conf_dir             => "/var/lib/redis/${redis_port}/",
    conf_maxmemory       => "${redis_max_memory}mb",
    conf_port            => $redis_port,
    # conf_slowlog_max_len is for compatibility with previous redis module
    conf_slowlog_max_len => '1024',
  }

  # FIXME: Remove when deployed to production.
  $old_sysvinit = 'redis_6379'
  file { "/etc/init.d/${old_sysvinit}":
    ensure => absent,
  }
  exec { 'remove_old_redis_sysvinit':
    command => "/usr/sbin/update-rc.d -f ${old_sysvinit} remove",
    onlyif  => "test -f /etc/rc0.d/K20${old_sysvinit} -o -f /etc/rc5.d/S20${old_sysvinit}",
  }

  $redis_mem_warn = $redis_max_memory * 0.8
  $redis_mem_crit = $redis_max_memory * 0.9

  @@icinga::check::graphite { "check_redis_memory_${::hostname}":
    target    => "${::fqdn_underscore}.redis_info.bytes-used_memory",
    warning   => to_bytes("${redis_mem_warn}M"),
    critical  => to_bytes("${redis_mem_crit}M"),
    desc      => 'redis memory usage',
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#redis-server-check',
    host_name => $::fqdn,
  }

  @@icinga::check::graphite { "check_redis_connected_clients_${::hostname}":
    target    => "${::fqdn_underscore}.redis_info.gauge-connected_clients",
    warning   => 1000,
    critical  => 2000,
    desc      => 'redis connected clients',
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#redis-server-check',
    host_name => $::fqdn,
  }

  class { 'collectd::plugin::redis': }
}
