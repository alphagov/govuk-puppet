class govuk::node::s_logs_redis {

  $redis_port = 6379

  include cpanm::install
  include govuk::node::s_base

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

  @nagios::plugin { 'check_redis':
    source  => 'puppet:///modules/govuk/node/s_redis/nagios/check_redis.pl',
    require => Package['Redis'],
  }

  @nagios::nrpe_config { 'check_redis':
    content => template('govuk/node/s_redis/nagios/check_redis.cfg.erb'),
  }

  @@nagios::check { "check_redis_${::hostname}":
    # Full details of arguments to check_redis can be found in
    #   modules/govuk/files/node/s_redis/nagios/check_redis.pl
    #
    # In summary, this:
    #   - warns if connection latency >1s, critical if >2s
    #   - warns if using >80% of system memory, critical if >90%
    #   - warns if >5 blocked clients, critical if >10
    #   - warns if >800 connected_clients, critical if >1000 connected_clients
    #   - warns if >10000 list length of logs, critical if >30000 list length of logs
    check_command       => "check_nrpe!check_redis!${redis_port} 1,2 80,90 blocked_clients,connected_clients 5,800 10,1000",
    service_description => 'redis server health',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#redis-server-check',
  }
  @@nagios::check { "check_redis_list_logs${::hostname}":
    check_command       => "check_nrpe!check_redis_list!${redis_port} LLEN,logs 10000 30000",
    service_description => 'redis list length for logs',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#redis-server-check',
  }

  # tagalog on all nodes forward directly to here.
  @ufw::allow { 'allow-redis-from-anywhere':
    from => '10.0.0.0/8',
    port => $redis_port;
  }

  @logrotate::conf { 'redis':
    matches => '/var/log/redis_*.log',
  }

  # Each redis machine is used by govuk::logstream as a message broker
  # for log data from applications. The logging elasticsearch cluster needs a
  # river for each redis server to read the data into a logstash-compatible
  # index.
  @@elasticsearch::river { "logging-${::hostname}":
    content => template('govuk/redis_river.json.erb'),
    tag     => 'logging',
  }

}
