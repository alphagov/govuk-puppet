class logstash::config {
  file { ['/etc/logstash', '/var/log/logstash'] :
    ensure => directory
  }
  file { '/etc/logstash/grok-patterns/' :
    source  => 'puppet:///modules/logstash/etc/logstash/grok-patterns/',
    recurse => true,
    require => File['/etc/logstash']
  }
}
