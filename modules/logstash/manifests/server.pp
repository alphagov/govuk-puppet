class logstash::server {
  class { 'logstash::server::package': }
  class { 'logstash::server::config':
    before => Class['logstash::server::package']
  }
  class { 'logstash::server::service':
    subscribe => Class['logstash::server::package']
  }
}
