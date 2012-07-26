class logstash::server::service {
  file { '/etc/init/elasticsearch-0-18-7.conf' :
    source  => 'puppet:///modules/logstash/etc/init/elasticsearch.conf',
    require => Exec['untar-elasticsearch']
  }
  file { '/etc/init/logstash-server.conf' :
    source => 'puppet:///modules/logstash/etc/init/logstash-server.conf'
  }
  service { 'logstash-server':
    ensure   => running,
    provider => upstart,
    require  => [File['/etc/init/logstash-server.conf'],Class['logstash::server::config']]
  }
  service { 'elasticsearch-0-18-7':
    ensure   => running,
    provider => upstart,
    require  => [File['/etc/init/elasticsearch-0-18-7.conf']]
  }

  service { 'rabbitmq-server':
    ensure   => running,
    require  => Package['rabbitmq-server']
  }
}
