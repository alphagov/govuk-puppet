class logstash::server::package {
  include logstash::package

  package {'rabbitmq-server':
    ensure => present,
  }

  package { 'pyes':
    ensure   => '0.19.1',
    provider => 'pip',
  }

  package { 'argparse':
    ensure   => '1.2.1',
    provider => 'pip',
  }

}
