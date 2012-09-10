class rabbitmq {

  apt::repository { 'cmsj-rabbitmq':
    type  => 'ppa',
    owner => 'cmsj',
    repo  => 'rabbitmq',
  }

  package { 'rabbitmq-server':
    ensure => present,
    name   => 'rabbitmq-server',
  }

  service { 'rabbitmq-server':
    ensure  => running,
    require => Package['rabbitmq-server'],
  }

  @ganglia::cronjob { 'rabbitmq':
    source => 'puppet:///modules/rabbitmq/rabbitmq_ganglia.sh',
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
