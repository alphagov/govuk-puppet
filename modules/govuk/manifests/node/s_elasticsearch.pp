class govuk::node::s_elasticsearch inherits govuk::node::s_base {

  $es_heap_size = $::memtotalmb / 4 * 3

  include java::oracle7::jre

  class { 'elasticsearch':
    cluster_name       => 'logging',
    heap_size          => "${es_heap_size}m",
    number_of_replicas => '0',
    require            => Class['java::oracle7::jre'],
  }

  elasticsearch::plugin { 'redis-river':
    install_from => 'leeadkins/elasticsearch-redis-river/0.0.4',
  }

  elasticsearch::plugin { 'head':
    install_from => 'mobz/elasticsearch-head',
  }

  # TODO: don't hard code index names in this script
  cron { 'elasticsearch-rotate-indices':
    ensure  => present,
    user    => 'nobody',
    hour    => '0',
    minute  => '1',
    command => '/usr/local/bin/elasticsearch-rotate-indices',
    require => Class['elasticsearch'],
  }

}
