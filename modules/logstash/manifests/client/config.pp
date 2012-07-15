class logstash::client::config {
  include logstash::config
  file { '/etc/logstash/logstash-client' :
    ensure  => directory,
    require => File['/etc/logstash']
  }
  file { '/etc/logstash/logstash-client/default.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-client/default.conf',
    require => File['/etc/logstash/logstash-client']
  }
}
