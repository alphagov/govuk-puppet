class logstash::service {
  file { '/etc/init/elasticsearch-0-18-7.conf' :
    source  => 'puppet:///modules/logstash/etc/init/elasticsearch.conf',
    require => Exec['untar-elasticsearch']
  }
  file { '/etc/init/logstash-server.conf' :
    source => 'puppet:///modules/logstash/etc/init/logstash-server.conf'
  }
  file { '/var/log/logstash' :
    ensure => directory
  }
  service { 'logstash-server':
    ensure   => running,
    provider => upstart,
    require  => [File['/etc/init/logstash-server.conf'],File['/var/log/logstash'],File['/etc/logstash/grok-patterns/apache-error']]
  }
  service { 'elasticsearch-0-18-7':
    ensure   => running,
    provider => upstart,
    require  => [File['/etc/init/elasticsearch-0-18-7.conf']]
  }
}
