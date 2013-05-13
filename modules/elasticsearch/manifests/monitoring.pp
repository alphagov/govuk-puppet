class elasticsearch::monitoring {

  @@nagios::check::graphite { "check_elasticsearch_jvm_gc_collection_time_in_millis-${::hostname}":
    target           => "summarize(${::fqdn_underscore}.curl_json-elasticsearch.counter-jvm_gc_collection_time_in_millis,\"5minutes\",\"max\",true)",
    desc             => 'Prolonged GC collection times',
    warning          => 150,
    critical         => 300,
    host_name        => $::fqdn,
    document_url     => 'https://sites.google.com/a/digital.cabinet-office.gov.uk/wiki/projects-and-processes/gov-uk/ops-manual/nagios-alerts-documentation-actions#TOC-Prolonged-GC-collection-times-Check',
  }

}
