class elasticsearch {

  package { 'elasticsearch':
    ensure => '0.19.8',
    notify => Exec['disable-default-elasticsearch'],
  }

  # We are installing elasticsearch in order to provide the .jar, but
  # configuration of individual ES nodes is done by elasticsearch::node.
  #
  # As such, we disable the default elasticsearch setup.
  exec { 'disable-default-elasticsearch':
    command     => '/etc/init.d/elasticsearch stop && /bin/rm /etc/init.d/elasticsearch && /usr/sbin/update-rc.d elasticsearch remove',
    refreshonly => true,
  }

  # Manage elasticsearch plugins, which are installed by elasticsearch::plugin
  file { '/usr/share/elasticsearch/plugins':
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { '/var/run/elasticsearch':
    ensure => directory,
  }

  file { '/var/log/elasticsearch':
    ensure  => directory,
    owner   => 'elasticsearch',
    group   => 'elasticsearch',
    require => Package['elasticsearch'], # need to wait for package to create ES user.
  }

  @logstash::collector { 'elasticsearch':
    source => 'puppet:///modules/elasticsearch/logstash.conf',
  }
  @ganglia::pymod { 'elasticsearch':
    source  => 'puppet:///modules/elasticsearch/elasticsearch.py',
  }
  @nagios::nrpe_config { 'check_elasticsearch':
    source => 'puppet:///modules/elasticsearch/check_elasticsearch.cfg',
  }
}
