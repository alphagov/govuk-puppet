define elasticsearch::node(
  $ensure = 'present',
  $cluster_hosts = ['localhost'],
  $cluster_name = $title,
  $heap_size = '512m',
  $http_port = '9200',
  $mlock_all = false,
  $number_of_replicas = '1',
  $number_of_shards = '5',
  $refresh_interval = '1s',
  $transport_port = '9300'
) {

  if ! ($ensure in ['present', 'absent']) {
    fail "Invalid \$ensure value for elasticsearch::node: '${ensure}'"
  }

  elasticsearch::node::config { $cluster_name:
    ensure             => $ensure,
    cluster_hosts      => $cluster_hosts,
    heap_size          => $heap_size,
    http_port          => $http_port,
    mlock_all          => $mlock_all,
    number_of_replicas => $number_of_replicas,
    number_of_shards   => $number_of_shards,
    refresh_interval   => $refresh_interval,
    transport_port     => $transport_port,
    require            => Class['elasticsearch'],
    notify             => Elasticsearch::Node::Service[$cluster_name],
  }

  elasticsearch::node::service { $cluster_name:
    ensure  => $ensure,
  }

}
