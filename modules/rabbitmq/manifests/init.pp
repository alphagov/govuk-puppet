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

  class { 'collectd::plugin::rabbitmq':  }

}
