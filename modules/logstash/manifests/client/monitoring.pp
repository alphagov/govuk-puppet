class logstash::client::monitoring {
  include nagios::client
  file { '/etc/nagios/nrpe.d/check_logstash_client.cfg':
    source  => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash_client.cfg',
    require => [Service['logstash-client'],Package['nagios-nrpe-server']],
    notify  => Service['nagios-nrpe-server'],
  }
  @@nagios::check { "check_logstash_client_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_client_running',
    service_description => "check logstash client running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
