define elasticsearch::node::config (
  $ensure,
  $cluster_hosts,
  $heap_size,
  $http_port,
  $mlock_all,
  $number_of_replicas,
  $number_of_shards,
  $refresh_interval,
  $transport_port,
  $cluster_name = $title
) {
  $es_home = "/var/apps/elasticsearch-${cluster_name}"

  $ensure_real = $ensure ? {
    'absent' => 'absent',
    default  => 'directory'
  }

  file { $es_home:
    ensure  => $ensure_real,
    recurse => true,
    purge   => true,
    force   => true,
  }

  if $ensure != 'absent' {

    file { "${es_home}/config":
      ensure  => directory,
      require => File[$es_home],
    }

    file { "${es_home}/config/elasticsearch.yml":
      ensure  => present,
      content => template('elasticsearch/elasticsearch.yml.erb'),
      require => File["${es_home}/config"],
    }

    file { "${es_home}/config/logging.yml":
      ensure  => present,
      source  => 'puppet:///modules/elasticsearch/logging.yml',
      require => File["${es_home}/config"],
    }

    file { "${es_home}/bin":
      ensure  => link,
      target  => '/usr/share/elasticsearch/bin',
      require => File[$es_home],
    }

    file { "${es_home}/lib":
      ensure  => link,
      target  => '/usr/share/elasticsearch/lib',
      require => File[$es_home],
    }

    file { "${es_home}/logs":
      ensure  => link,
      target  => '/var/log/elasticsearch',
      require => File[$es_home],
    }

    file { '/mnt/elasticsearch':
      ensure => directory
      }

    file { "${es_home}/data":
      ensure  => link,
      target  => '/mnt/elasticsearch',
      require => [File[$es_home], File['/mnt/elasticsearch']],
    }

  }

  @ganglia::pyconf { "elasticsearch-${cluster_name}":
    content => template('elasticsearch/elasticsearch.pyconf.erb'),
  }

  @@nagios::check { "check_elasticsearch-${cluster_name}_running_on_${::hostname}":
    check_command       => "check_nrpe!check_elasticsearch!${http_port}",
    service_description => "check elasticsearch running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
