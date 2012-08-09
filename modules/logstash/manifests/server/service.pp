class logstash::server::service {

  file { '/etc/init/logstash-server.conf':
    source => 'puppet:///modules/logstash/etc/init/logstash-server.conf',
    notify => Service['logstash-server'],
  }

  service { 'logstash-server':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/logstash-server.conf']
  }

  service { 'rabbitmq-server':
    ensure => running,
  }

  @nagios::nrpe_config { 'check_logstash_server':
    source => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash_server.cfg',
  }

  @ganglia::cronjob { 'rabbitmq':
    source => 'puppet:///modules/logstash/bin/rabbitmq_ganglia.sh',
  }

  @@nagios::check { "check_logstash_server_running_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_logstash_server_running',
    service_description => "check logstash server running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_rabbitmq_consumers_${::hostname}":
    check_command       => 'check_ganglia_metric!rabbitmq.consumers!1:2.99!-1:0.99',
    service_description => "check rabbitmq has some consumers on ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_rabbitmq_queue_${::hostname}":
    check_command       => 'check_ganglia_metric!rabbitmq.messages!1000!10000',
    service_description => "check depth of rabbitmq queue on ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
