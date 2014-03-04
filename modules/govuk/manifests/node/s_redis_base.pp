class govuk::node::s_redis_base {
  include cpanm::install
  include govuk::node::s_base

  $redis_port = 6379
  $redis_max_memory = $::memtotalmb / 4 * 3

  class { 'redis':
    redis_max_memory => "${redis_max_memory}mb",
    redis_port       => $redis_port,
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

  # The check_redis nagios plugin (below) requires this perl module
  package { 'Redis':
    ensure   => present,
    provider => 'cpanm',
  }

  @icinga::plugin { 'check_redis':
    source  => 'puppet:///modules/govuk/node/s_redis/nagios/check_redis.pl',
    require => Package['Redis'],
  }

  @icinga::nrpe_config { 'check_redis':
    content => template('govuk/node/s_redis/nagios/check_redis.cfg.erb'),
  }

  @@icinga::check { "check_redis_${::hostname}":
    # Full details of arguments to check_redis can be found in
    #   modules/govuk/files/node/s_redis/nagios/check_redis.pl
    #
    # In summary, this:
    #   - warns if connection latency >1s, critical if >2s
    #   - warns if >800 connected_clients, critical if >1000 connected_clients
    check_command       => "check_nrpe!check_redis!${redis_port} 1,2 connected_clients 800 1000",
    service_description => 'redis server health',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#redis-server-check',
  }

  @logrotate::conf { 'redis':
    matches => '/var/log/redis_*.log',
  }

  class { 'collectd::plugin::redis': }
}
