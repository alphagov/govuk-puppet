class logstash::package {
  include wget
  file { '/var/apps':
    ensure    => directory
  }
  file { '/var/apps/logstash':
    ensure    => directory,
    require   => File['/var/apps']
  }
  wget::fetch { 'logstash-monolithic':
    source      => 'http://semicomplete.com/files/logstash/logstash-1.1.0-monolithic.jar',
    destination => '/var/apps/logstash/logstash-1.1.0-monolithic.jar',
    require     => File['/var/apps/logstash']
  }
}
