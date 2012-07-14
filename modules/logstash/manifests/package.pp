class logstash::package {
  include wget
  file { ['/var/apps', '/var/apps/logstash']:
    ensure  => directory
  }
  file { '/usr/local/bin/logstash':
    ensure => present,
    source => 'puppet:///modules/logstash/bin/logstash',
    mode   => '0755'
  }
  wget::fetch { 'logstash-monolithic':
    source      => 'https://gds-public-readable-tarballs.s3.amazonaws.com/logstash-1.1.0.2-monolithic.jar',
    destination => '/var/apps/logstash/logstash-1.1.0.2-monolithic.jar',
    require     => File['/var/apps/logstash']
  }
}
