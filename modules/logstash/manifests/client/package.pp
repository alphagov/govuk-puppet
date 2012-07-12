class logstash::client::package {
  include wget
  file { '/var/apps':
    ensure    => directory
  }
  file { '/var/apps/logstash':
    ensure    => directory,
    require   => File['/var/apps']
  }
  wget::fetch { 'logstash-monolithic':
    source      => 'https://gds-public-readable-tarballs.s3.amazonaws.com/logstash-1.1.0.2-monolithic.jar',
    destination => '/var/apps/logstash/logstash-1.1.0.2-monolithic.jar',
    require     => File['/var/apps/logstash']
  }
}
