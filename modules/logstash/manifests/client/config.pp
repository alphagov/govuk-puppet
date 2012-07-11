class logstash::client::config {
  file { '/etc/logstash' :
    ensure => directory
  }
  file { '/etc/logstash/logstash-client.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-client.conf',
    require => File['/etc/logstash']
  }
}
