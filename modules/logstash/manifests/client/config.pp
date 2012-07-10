class logstash::client::config {
  file { '/etc/logstash' :
    ensure => directory
  }
  file { '/etc/logstash/logstash.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash.conf',
    require => File['/etc/logstash']
  }
}
