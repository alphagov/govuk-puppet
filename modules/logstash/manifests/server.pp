class logstash::server {
  class { 'logstash::server::package': }
  class { 'logstash::server::config':
    before    => Class['logstash::server::package']
  }
  class { 'logstash::server::service':
    subscribe => [Class['logstash::server::package'],Class['logstash::server::config']],
    before    => Class['logstash::server::monitoring']
  }
  class { 'logstash::server::monitoring': }
}
