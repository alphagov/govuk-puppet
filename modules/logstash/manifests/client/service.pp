class logstash::client::service {
  file { '/etc/init/logstash-client.conf':
    source => 'puppet:///modules/logstash/etc/init/logstash-client.conf'
  }

  service { 'logstash-client':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/logstash-client.conf'],
  }

  @nagios::nrpe_config { 'check_logstash_client':
    source  => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash_client.cfg',
  }

  @@nagios::check { "check_logstash_client_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_client_running',
    service_description => "check logstash client running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
