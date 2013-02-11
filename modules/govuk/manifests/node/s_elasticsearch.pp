class govuk::node::s_elasticsearch inherits govuk::node::s_base {


  include java::openjdk6::jre
  class {'elasticsearch':
      require => Class['java::openjdk6::jre'],
  }
  elasticsearch::node { "govuk-${::govuk_platform}":
    heap_size          => '2g',
    number_of_replicas => '0',
  }
}
