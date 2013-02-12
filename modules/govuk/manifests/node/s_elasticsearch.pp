class govuk::node::s_elasticsearch inherits govuk::node::s_base {

  $es_heap_size = $::memtotalmb / 4 * 3

  include java::oracle7::jre

  class { 'elasticsearch':
    cluster_name       => 'logging',
    heap_size          => "${es_heap_size}m",
    number_of_replicas => '0',
    require            => Class['java::oracle7::jre'],
  }

}
