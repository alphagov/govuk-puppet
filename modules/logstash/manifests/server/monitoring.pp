class logstash::server::monitoring {
  include nagios::client
  file { '/etc/nagios/nrpe.d/check_logstash.cfg':
    source  => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash.cfg',
    require => [Service['logstash-server'],Package['nagios-nrpe-server']],
    notify  => Service['nagios-nrpe-server'],
  }
  @@nagios::check { "check_logstash_server_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_running',
    service_description => "check logstash server running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
