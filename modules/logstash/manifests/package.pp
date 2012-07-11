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
    source      => 'http://semicomplete.com/files/logstash/logstash-1.1.1-rc2-monolithic.jar',
    destination => '/var/apps/logstash/logstash-1.1.1-rc2-monolithic.jar',
    require     => File['/var/apps/logstash']
  }
  wget::fetch { 'elasticsearch':
    source      => 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.18.7.tar.gz',
    destination => '/tmp/elasticsearch-0.18.7.tar.gz'
  }
  package {'rabbitmq-server':
    ensure  => installed,
    require => Wget::Fetch['logstash-monolithic']
  }
  exec { 'untar-elasticsearch':
    command => 'tar zxf /tmp/elasticsearch-0.18.7.tar.gz',
    cwd     => '/var/apps/',
    unless  => 'test -s /var/apps/elasticsearch-0.18.7',
    require => [File['/var/apps'],Wget::Fetch['elasticsearch']]
  }

}
