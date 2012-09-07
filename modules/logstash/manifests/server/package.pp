class logstash::server::package inherits logstash::package {

  include rabbitmq

  package { 'pyes':
    ensure   => '0.19.1',
    provider => 'pip',
  }

  package { 'argparse':
    ensure   => '1.2.1',
    provider => 'pip',
  }

}
