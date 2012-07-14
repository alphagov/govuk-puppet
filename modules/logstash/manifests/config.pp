class logstash::config {
  file { ['/etc/logstash', '/etc/logstash/grok-patterns', '/var/log/logstash'] :
    ensure => directory
  }
  file { '/etc/logstash/grok-patterns/apache-error' :
    source  => 'puppet:///modules/logstash/etc/logstash/grok-patterns/apache-error',
    require => File['/etc/logstash/grok-patterns']
  }
}
