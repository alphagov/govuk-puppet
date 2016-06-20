# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_logs_redis inherits govuk::node::s_redis_base {
  $redis_port = 6379

  @@icinga::check::graphite { "check_redis_list_logs${::hostname}":
    target    => "${::fqdn_metrics}.redis_queues.gauge-logs",
    warning   => 10000,
    critical  => 30000,
    desc      => 'redis list length for logs',
    notes_url => monitoring_docs_url('redis', true),
    host_name => $::fqdn,
  }

  # tagalog on all nodes forward directly to here.
  @ufw::allow { 'allow-redis-from-anywhere':
    from => 'any',
    port => $redis_port;
  }

  # Each redis machine is used by govuk_logging::logstream as a message broker
  # for log data from applications. The logging elasticsearch cluster needs a
  # river for each redis server to read the data into a logstash-compatible
  # index.
  @@govuk_elasticsearch::river { "logging-${::hostname}":
    content => template('govuk/node/s_logs_redis/redis_river.json.erb'),
    tag     => 'logging',
  }

  class { 'collectd::plugin::redis_queues':
    queues => ['logs'],
  }
}
