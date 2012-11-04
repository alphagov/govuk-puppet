class logstash::server::service (
  $http_port,
  $transport_port
) {

  file { '/etc/init/logstash-server.conf':
    content => template('logstash/etc/init/logstash-server.conf.erb'),
    notify  => Service['logstash-server'],
  }

  service { 'logstash-server':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/logstash-server.conf']
  }

  @nagios::nrpe_config { 'check_logstash_server':
    source => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash_server.cfg',
  }

  @@nagios::check { "check_logstash_server_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_server_running',
    service_description => "logstash-server not running",
    host_name           => $::fqdn,
  }

}
