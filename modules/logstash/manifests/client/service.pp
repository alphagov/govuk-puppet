class logstash::client::service {
  file { '/etc/init/logstash-client.conf' :
    source => 'puppet:///modules/logstash/etc/init/logstash-client.conf'
  }
  file { '/var/log/logstash' :
    ensure => directory
  }
  service { 'logstash-client' :
    ensure   => running,
    provider => upstart,
    require  => [File['/etc/init/logstash-client.conf'],File['/var/log/logstash']]
  }
}
