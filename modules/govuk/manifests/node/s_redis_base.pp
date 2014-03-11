class govuk::node::s_redis_base {
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

  # FIXME: Remove when deployed.
  package { ['cpanminus', 'perl-doc']:
    ensure => purged,
  }
  @icinga::plugin { 'check_redis':
    ensure  => absent,
  }

  @logrotate::conf { 'redis':
    matches => '/var/log/redis_*.log',
  }

  class { 'collectd::plugin::redis': }
}
