class logstash {
  class { 'logstash::config':
    before => Class['logstash::package']
  }
  class { 'logstash::package': }
  class { 'logstash::service':
    subscribe => Class['logstash::package']
  }
}
