class logstash::package {

  $logstash_version = '1.1.1'

  include openjdk

  group { 'logstash':
    ensure  => 'present',
  }

  user { 'logstash':
    ensure      => present,
    home        => '/var/apps/logstash',
    shell       => '/bin/false',
    gid         => 'logstash',
    groups      => ['adm'], # needs this group to read syslog etc.
    require     => Group['logstash'];
  }

  file { '/var/apps/logstash':
    ensure  => directory,
    owner   => 'logstash',
    group   => 'logstash',
    require => [User['logstash'], Group['logstash']],
  }

  file { '/etc/logstash':
    ensure => directory,
  }

  file { ['/var/log/logstash', '/var/run/logstash']:
    ensure  => directory,
    owner   => 'logstash',
    group   => 'logstash',
    require => [User['logstash'], Group['logstash']],
  }

  wget::fetch { 'logstash-monolithic':
    source      => "http://semicomplete.com/files/logstash/logstash-${logstash_version}-monolithic.jar",
    destination => "/var/apps/logstash/logstash-${logstash_version}-monolithic.jar",
    require     => File['/var/apps/logstash'],
  }

  file { '/var/apps/logstash/logstash.jar':
    ensure => link,
    target => "/var/apps/logstash/logstash-${logstash_version}-monolithic.jar",
  }
}
