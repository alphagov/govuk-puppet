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
  exec { 'easy_install pyes':
    command => 'easy_install pyes',
    creates => '/usr/local/lib/python2.6/dist-packages/pyes-0.19.1-py2.6.egg'
  }
  exec { 'easy_install argparse':
    command => 'easy_install argparse',
    creates => '/usr/local/lib/python2.6/dist-packages/argparse-1.2.1-py2.6.egg'
  }
}
