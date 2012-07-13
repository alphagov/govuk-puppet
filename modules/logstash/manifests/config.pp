class logstash::config {
  file { '/etc/logstash' :
    ensure => directory
  }
  file { '/etc/logstash/grok-patterns' :
    ensure => directory
  }
  file { '/etc/logstash/logstash-server.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-server.conf',
    require => File['/etc/logstash']
  }
  file { '/etc/logstash/grok-patterns/apache-error' :
    source  => 'puppet:///modules/logstash/etc/logstash/grok-patterns/apache-error',
    require => File['/etc/logstash/grok-patterns']
  }
}
