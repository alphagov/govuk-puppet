class logstash::server {
  class { 'logstash::server::package': }
  class { 'logstash::server::config':  }
  class { 'logstash::server::service': }
  class { 'logstash::server::monitoring': }

  Class['logstash::server::package'] -> Class['logstash::server::config'] ~> Class['logstash::server::service']
  Class['logstash::server::service'] -> Class['logstash::server::monitoring']
  Class['logstash::server::package'] -> Class['logstash::server::service']
  Class['logstash::server::package'] ~> Class['logstash::server::service']
}
