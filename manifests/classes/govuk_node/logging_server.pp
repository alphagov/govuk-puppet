class govuk_node::logging_server inherits govuk_node::base {
  include elasticsearch
  include nagios::client
  include nginx

  @@backup::directory {"backup_aggregated_logstash_$::hostname":
    directory => '/data/logging/logstash-aggregation',
    host_name => $::hostname,
    fq_dn     => $::fqdn,
  }

  if $::govuk_provider == 'sky' {
    $es_heap_size = '8g'
  } else {
    $es_heap_size = '4g'
  }

  class { 'logstash::server':
    es_heap_size => $es_heap_size,
  }

  nginx::config::vhost::proxy {
    "logging.${::govuk_platform}.alphagov.co.uk":
      to        => ['localhost:9292'],
      aliases   => ["graylog.${::govuk_platform}.alphagov.co.uk"],
  }
}
