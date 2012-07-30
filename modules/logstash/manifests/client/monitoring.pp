class logstash::client::monitoring {
  include nagios::client
  include logstash::common
  @@nagios::check { "check_logstash_client_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_running',
    service_description => "check logstash client running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
