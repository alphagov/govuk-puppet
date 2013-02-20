class govuk::node::s_redis {

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
    #   modules/govuk/files/node/s_redis/nagios/check_redis.cfg
    #
    # In summary, this:
    #   - warns if connection latency >1s, critical if >2s
    #   - warns if using >80% of system memory, critical if >90%
    #   - warns if >50 blocked clients, critical if >100
    #   - report connected_clients in nagios status text
    check_command       => "check_nrpe!check_redis!${redis_port} 1,2 80,90 blocked_clients,connected_clients 50,~ 100,~",
    service_description => 'redis server',
    host_name           => $::fqdn,
  }

  @ufw::allow {
    'allow-redis-from-backend':
      from => '10.3.0.0/16',
      port => $redis_port;
    'allow-redis-from-frontend':
      from => '10.2.0.0/16',
      port => $redis_port;
    'allow-redis-from-management':
      from => '10.0.0.0/16',
      port => $redis_port;
  }

  @logrotate::conf { 'redis':
    matches => '/var/log/redis_*.log',
  }

  # Each redis machine is used by the govuk_logpipe tool as a message broker
  # for log data from applications. The logging elasticsearch cluster needs a
  # river for each redis server to read the data into a logstash-compatible
  # index.
  @@elasticsearch::river { "logging-${::hostname}":
    content => template('govuk/redis_river.json.erb'),
    tag     => 'logging',
  }

}
