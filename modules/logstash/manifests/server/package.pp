class logstash::server::package inherits logstash::package {

  include rabbitmq

  class { 'elasticsearch':
    require => Class['java::openjdk6::jre'],
  }

  package { 'pyes':
    ensure   => '0.19.1',
    provider => 'pip',
  }

  package { 'argparse':
    ensure   => '1.2.1',
    provider => 'pip',
  }

  package { 'apdex':
    ensure   => installed,
    provider => 'gem',
  }

}
