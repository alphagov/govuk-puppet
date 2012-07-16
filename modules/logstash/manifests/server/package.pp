class logstash::server::package {
  include logstash::package
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
