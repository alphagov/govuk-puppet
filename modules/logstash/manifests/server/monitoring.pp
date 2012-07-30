class logstash::server::monitoring {
  include nagios::client
  include ganglia::client
  file { '/etc/nagios/nrpe.d/check_logstash_server.cfg':
    source  => 'puppet:///modules/logstash/etc/nagios/nrpe.d/check_logstash_server.cfg',
    require => [Service['logstash-server'],Package['nagios-nrpe-server']],
    notify  => Service['nagios-nrpe-server'],
  }
  file { '/usr/local/bin/rabbitmq_ganglia.sh':
    source  => 'puppet:///modules/logstash/bin/rabbitmq_ganglia.sh',
    require => [Package['rabbitmq-server'],Service['ganglia-monitor']],
    mode    => '0755',
  }
  cron { 'rabbitmq-ganglia':
    command => '/usr/local/bin/rabbitmq_ganglia.sh',
    user    => root,
    minute  => '*',
    require => File['/usr/local/bin/rabbitmq_ganglia.sh'],
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
