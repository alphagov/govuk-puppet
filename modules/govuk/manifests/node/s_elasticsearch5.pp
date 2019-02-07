# == Class: govuk::node::s_elasticsearch5
#
# Machines for the elasticsearch cluster in the API vDC
#
class govuk::node::s_elasticsearch5 inherits govuk::node::s_base {
  include govuk_java::openjdk8::jdk
  include govuk_java::openjdk8::jre
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk8',
    jre => 'openjdk8',
  }

  include govuk_env_sync

  $es_heap_size = floor($::memorysize_mb / 2)

  class { 'govuk_elasticsearch::dump':
    require => Class['govuk_elasticsearch'], # required for elasticsearch user to exist
  }

  class { 'govuk_elasticsearch':
    cluster_hosts        => ['elasticsearch5-1.api:9300', 'elasticsearch5-2.api:9300', 'elasticsearch5-3.api:9300'],
    cluster_name         => 'govuk-content',
    heap_size            => "${es_heap_size}m",
    number_of_replicas   => '1',
    host                 => $::fqdn,
    require              => Class['govuk_java::openjdk8::jre'],
    aws_cluster_name     => "elasticsearch5-${::aws_stackname}",
    log_slow_queries     => true,
    slow_query_log_level => 'info',
    version              => '5.6.14',
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
