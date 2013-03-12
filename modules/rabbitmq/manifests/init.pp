class rabbitmq {

  include govuk::ppa

  package { 'rabbitmq-server':
    ensure => present,
    name   => 'rabbitmq-server',
  }

  @ufw::allow { "allow-amqp-from-all":
    port => 5672,
  }

  service { 'rabbitmq-server':
    ensure  => running,
    require => Package['rabbitmq-server'],
  }

  @ganglia::cronjob { 'rabbitmq':
    source => 'puppet:///modules/rabbitmq/rabbitmq_ganglia.sh',
  }

  class { 'collectd::plugin::rabbitmq':  }

}
