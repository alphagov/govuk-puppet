class elasticsearch::monitoring {

  @@nagios::check::graphite { "check_elasticsearch_jvm_gc_collection_time_in_millis-${::hostname}":
    target       => "${::fqdn_underscore}.curl_json-elasticsearch.counter-jvm_gc_collection_time_in_millis",
    desc         => 'Prolonged GC collection times',
    warning      => 50,
    critical     => 250,
    host_name    => $::fqdn,
    document_url => '',
  }

}
