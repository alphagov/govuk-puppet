class elasticsearch::monitoring (
  $http_port,
  $log_index_type_count,
) {

  class { 'collectd::plugin::elasticsearch':
    es_port              => $http_port,
    log_index_type_count => $log_index_type_count,
  }

  @@nagios::check::graphite { "check_elasticsearch_jvm_gc_collection_time_in_millis-${::hostname}":
    target           => "summarize(${::fqdn_underscore}.curl_json-elasticsearch.counter-jvm_gc_collection_time_in_millis,\"5minutes\",\"max\",true)",
    desc             => 'Prolonged GC collection times',
    warning          => 150,
    critical         => 300,
    host_name        => $::fqdn,
    notes_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#prolonged-gc-collection-times-check',
  }

}
