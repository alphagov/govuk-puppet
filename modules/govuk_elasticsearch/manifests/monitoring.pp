# == Class govuk_elasticsearch::monitoring
#
# Setup monitoring for an elasticsearch node
#
# === Parameters
#
# FIXME: Document missing parameters
#
class govuk_elasticsearch::monitoring (
  $host_count,
  $cluster_name,
  $http_port,
  $log_index_type_count,
  $disable_gc_alerts,
) {

  collectd::plugin::process { "elasticsearch-${cluster_name}":
    ensure => 'absent',
    regex  => '.*/bin/java .*/usr/share/elasticsearch .*',
  }
}
