class logstash::service {
  file { '/etc/init/logstash-server.conf' :
    source => 'puppet:///modules/logstash/etc/init/logstash-server.conf'
  }
  file { '/var/log/logstash' :
    ensure => directory
  }
  service { 'logstash-server':
    ensure   => running,
    provider => upstart,
    require  => [File['/etc/init/logstash-server.conf'],File['/var/log/logstash']]
  }
}
