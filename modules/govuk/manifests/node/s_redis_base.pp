class govuk::node::s_redis_base {
  include cpanm::install
  include govuk::node::s_base

  $redis_port = 6379
  $redis_max_memory = $::memtotalmb / 4 * 3

  class { 'redis':
    redis_max_memory => "${redis_max_memory}mb",
    redis_port       => $redis_port,
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
    #   - warns if using >80% of system memory, critical if >90%
    #   - warns if >800 connected_clients, critical if >1000 connected_clients
    check_command       => "check_nrpe!check_redis!${redis_port} 1,2 80,90 connected_clients 800 1000",
    service_description => 'redis server health',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#redis-server-check',
  }

  @logrotate::conf { 'redis':
    matches => '/var/log/redis_*.log',
  }

  class { 'collectd::plugin::redis': }
}
