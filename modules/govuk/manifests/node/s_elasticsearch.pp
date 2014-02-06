class govuk::node::s_elasticsearch inherits govuk::node::s_base {
  include java::oracle7::jre

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  $es_heap_size = $::memtotalmb / 4 * 3

  include elasticsearch::dump

  class { 'elasticsearch':
    version              => "0.20.6-ppa1~${::lsbdistcodename}1",
    cluster_hosts        => ['elasticsearch-1.backend:9300', 'elasticsearch-2.backend:9300', 'elasticsearch-3.backend:9300'],
    cluster_name         => "govuk-${::govuk_platform}",
    heap_size            => "${es_heap_size}m",
    number_of_replicas   => '1',
    minimum_master_nodes => '2',
    host                 => $::fqdn,
    require              => Class['java::oracle7::jre'],
  }

  elasticsearch::plugin { 'head':
    install_from => 'mobz/elasticsearch-head',
  }

  collectd::plugin::tcpconn { 'es-9200':
    incoming => 9200,
    outgoing => 9200,
  }
  collectd::plugin::tcpconn { 'es-9300':
    incoming => 9300,
    outgoing => 9300,
  }

  #FIXME: remove if when we have moved to platform one
  if hiera(use_hiera_disks,false) {
    Govuk::Mount['/mnt/elasticsearch'] -> Class['elasticsearch']
  }
}
