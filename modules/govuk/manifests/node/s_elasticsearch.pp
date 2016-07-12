# == Class: govuk::node::s_elasticsearch
#
# Class to define machines that run ElasticSearch
#
class govuk::node::s_elasticsearch inherits govuk::node::s_base {
  include govuk_java::oracle7::jre

  class { 'govuk_java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  $es_heap_size = floor($::memorysize_mb / 2)

  class { 'govuk_elasticsearch::dump':
    require => Class['govuk_elasticsearch'], # required for elasticsearch user to exist
  }

  class { 'govuk_elasticsearch':
    cluster_hosts      => ['elasticsearch-1.backend:9300', 'elasticsearch-2.backend:9300', 'elasticsearch-3.backend:9300'],
    cluster_name       => 'govuk-production',
    heap_size          => "${es_heap_size}m",
    number_of_replicas => '1',
    host               => $::fqdn,
    require            => [Class['govuk_java::oracle7::jre'],Class['govuk_java::set_defaults']],
  }

  collectd::plugin::tcpconn { 'es-9200':
    incoming => 9200,
    outgoing => 9200,
  }
  collectd::plugin::tcpconn { 'es-9300':
    incoming => 9300,
    outgoing => 9300,
  }

  Govuk_mount['/mnt/elasticsearch'] -> Class['govuk_elasticsearch']
}
