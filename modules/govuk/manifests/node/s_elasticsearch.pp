class govuk::node::s_elasticsearch inherits govuk::node::s_base {
  include java::oracle7::jre
  class { 'elasticsearch':
    require => Class['java::oracle7::jre'],
  }
  elasticsearch::node { 'logging':
    heap_size          => '12g',
    number_of_replicas => '0',
  }
}
