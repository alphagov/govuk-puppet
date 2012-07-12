class logstash::config {
  file { '/etc/logstash' :
    ensure => directory
  }
  file { '/etc/logstash/logstash-server.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-server.conf',
    require => File['/etc/logstash']
  }
}
