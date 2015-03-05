# == Class: govuk::node::s_api_elasticsearch
#
# Machines for the elasticsearch cluster in the API vDC
#
class govuk::node::s_api_elasticsearch inherits govuk::node::s_base {
  include govuk_java::openjdk7::jre

  $es_heap_size = $::memtotalmb / 2

  class { 'govuk_elasticsearch::dump':
    require => Class['govuk_elasticsearch'], # required for elasticsearch user to exist
  }

  class { 'govuk_elasticsearch':
    cluster_hosts        => ['api-elasticsearch-1.api:9300', 'api-elasticsearch-2.api:9300', 'api-elasticsearch-3.api:9300'],
    cluster_name         => 'govuk-production',
    heap_size            => "${es_heap_size}m",
    number_of_replicas   => '1',
    minimum_master_nodes => '2',
    host                 => $::fqdn,
    require              => Class['govuk_java::openjdk7::jre'],
  }

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    module_dir => 'head',
    instances  => $::fqdn,
  }

  collectd::plugin::tcpconn { 'es-9200':
    incoming => 9200,
    outgoing => 9200,
  }
  collectd::plugin::tcpconn { 'es-9300':
    incoming => 9300,
    outgoing => 9300,
  }

  Govuk::Mount['/mnt/elasticsearch'] -> Class['govuk_elasticsearch']
}
