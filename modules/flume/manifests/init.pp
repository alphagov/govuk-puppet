class flume {
  apt::deb_repository { 'cloudera':
    url => "http://archive.cloudera.com/debian",
    repo => "contrib",
    dist => "lucid-cdh3",
    key_name => 'archive.key',
    key_url => 'http://archive.cloudera.com/debian'
  }

  package { 'flume':
    ensure => installed,
    require => [
      Apt::Deb_repository['cloudera'],
      Class['java']
    ]
  }

  package { 'flume-master':
    ensure => installed,
    require => Package['flume']
  }

  service { 'flume-master':
    ensure => running,
    require => Package['flume-master']
  }

  package { 'flume-node':
    ensure => installed,
    require => Package['flume']
  }

  service { 'flume-node':
    ensure => running,
    require => Package['flume-node']
  }

  file { '/var/log/flume/user':
    ensure => directory,
    require => Package['flume'],
    owner => 'flume',
    group => 'flume'
  }

  flume_node { $fqdn:
    master => 'support.cluster',
    source => "tail(\"/var/log/solr/solr.log\", startFromEnd=\"true\")",
    sink   => "collectorSink(\"file:///var/log/flume/user/system/%Y-%m-%d/%H00/\", \"%{host}-\")",
    ensure => insync,
    require => [
      Service['flume-master'],
      Service['flume-node']
    ]
  }
}
