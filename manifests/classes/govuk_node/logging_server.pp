class govuk_node::logging_server inherits govuk_node::base {
  include nagios::client
  include nginx

  if $::govuk_provider == 'sky' {
    $es_heap_size = '8g'
  } else {
    $es_heap_size = '4g'
  }

  class { 'logstash::server':
    es_heap_size => $es_heap_size,
  }

  $app_domain = extlookup('app_domain')

  nginx::config::vhost::proxy {
    "logging.${app_domain}":
      to        => ['localhost:9292'],
      aliases   => ["graylog.${app_domain}"],
  }
}
