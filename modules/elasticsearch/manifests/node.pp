define elasticsearch::node(
  $ensure = 'present',
  $cluster_name = $title,
  $cluster_hosts = ['localhost'],
  $heap_size = '512m',
  $http_port = '9200',
  $transport_port = '9300',
  $number_of_shards = '5',
  $number_of_replicas = '1',
  $mlock_all = false
) {

  if ! ($ensure in ['present', 'absent']) {
    fail "Invalid \$ensure value for elasticsearch::node: '${ensure}'"
  }

  elasticsearch::node::config { $cluster_name:
    ensure             => $ensure,
    cluster_hosts      => $cluster_hosts,
    heap_size          => $heap_size,
    http_port          => $http_port,
    transport_port     => $transport_port,
    number_of_shards   => $number_of_shards,
    number_of_replicas => $number_of_replicas,
    mlock_all          => $mlock_all,
    require            => Class['elasticsearch'],
    notify             => Elasticsearch::Node::Service[$cluster_name],
  }

  elasticsearch::node::service { $cluster_name:
    ensure  => $ensure,
    require => Elasticsearch::Node::Config[$cluster_name],
  }

}
