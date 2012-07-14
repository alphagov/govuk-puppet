class logstash::client::config {
  file { ['/etc/logstash', '/etc/logstash/logstash-client', '/etc/logstash/grok-patterns'] :
    ensure => directory
  }
  file { '/etc/logstash/logstash-client/default.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-client/default.conf',
    require => File['/etc/logstash/logstash-client']
  }
  file { '/etc/logstash/logstash-client/apache.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-client/apache.conf',
    require => File['/etc/logstash/logstash-client']
  }
  file { '/etc/logstash/grok-patterns/apache-error' :
    source  => 'puppet:///modules/logstash/etc/logstash/grok-patterns/apache-error',
    require => File['/etc/logstash/grok-patterns']
  }

}
