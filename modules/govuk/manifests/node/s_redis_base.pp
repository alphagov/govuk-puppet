class govuk::node::s_redis_base {
  include govuk::node::s_base

  $redis_port = 6379
  $redis_max_memory = $::memtotalmb / 4 * 3

  class { 'redis':
    # conf_dir is needed for compatibility with previous redis module
    conf_dir                           => "/var/lib/redis/${redis_port}/",
    conf_maxmemory                     => "${redis_max_memory}mb",
    conf_port                          => $redis_port,
    # conf_slowlog_max_len is for compatibility with previous redis module
    conf_slowlog_max_len               => '1024',
    # TODO: These don't work in 2.6.6 so setting to false
    # consider changing if we update redis version
    conf_aof_rewrite_incremental_fsync => false,
    conf_hz                            => false,
    conf_repl_disable_tcp_nodelay      => false,
    conf_tcp_keepalive                 => false,
    # end TODO
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

  class { 'collectd::plugin::redis': }
}
