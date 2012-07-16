class logstash::server::config {
  include logstash::config
  file { '/etc/logstash/logstash-server.conf' :
    source  => 'puppet:///modules/logstash/etc/logstash/logstash-server.conf',
    require => File['/etc/logstash']
  }
}
