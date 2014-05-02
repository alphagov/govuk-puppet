class elasticsearch_old (
  $cluster_hosts = ['localhost'],
  $cluster_name = 'elasticsearch',
  $heap_size = '512m',
  $http_port = '9200',
  $mlock_all = false,
  $minimum_master_nodes = '1',
  $host = 'localhost',
  $number_of_replicas = '1',
  $number_of_shards = '5',
  $refresh_interval = '1s',
  $transport_port = '9300',
  $version = 'present',
  $log_index_type_count = {},
  $disable_gc_alerts = false
) {

  anchor { 'elasticsearch_old::begin':
    notify => Class['elasticsearch_old::service'];
  }

  class { 'elasticsearch_old::package':
    require => Anchor['elasticsearch_old::begin'],
    notify  => Class['elasticsearch_old::service'],
    version => $version;
  }

  class { 'elasticsearch_old::config':
    cluster_hosts        => $cluster_hosts,
    cluster_name         => $cluster_name,
    heap_size            => $heap_size,
    http_port            => $http_port,
    mlock_all            => $mlock_all,
    number_of_replicas   => $number_of_replicas,
    number_of_shards     => $number_of_shards,
    refresh_interval     => $refresh_interval,
    transport_port       => $transport_port,
    minimum_master_nodes => $minimum_master_nodes,
    host                 => $host,
    require              => Class['elasticsearch_old::package'],
    notify               => Class['elasticsearch_old::service'];
  }

  class { 'elasticsearch_old::service':
    cluster_name => $cluster_name,
    notify       => Anchor['elasticsearch_old::end'],
  }

  anchor { 'elasticsearch_old::end': }

  class { 'govuk_elasticsearch::monitoring':
    host_count           => size($cluster_hosts),
    cluster_name         => $cluster_name,
    http_port            => $http_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
  }

  @ufw::allow { "allow-elasticsearch-http-${http_port}-from-all":
    port => $http_port,
  }

  @ufw::allow { "allow-elasticsearch-transport-${transport_port}-from-all":
    port => $transport_port;
  }

}
