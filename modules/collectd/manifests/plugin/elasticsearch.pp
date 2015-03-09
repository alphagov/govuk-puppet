# == Class: collectd::plugin::elasticsearch
#
# Setup collectd plugin to monitor an elasticsearch node
#
# === Parameters
#
# FIXME: Document missing parameters
#
# [*legacy_elasticsearch*]
#   Whether this is a pre-1.x elasticsearch installation.  Defaults to false
#
class collectd::plugin::elasticsearch(
  $es_port,
  $log_index_type_count = {},
  $legacy_elasticsearch = false,
) {
  include collectd::plugin::curl_json

  # FIXME: remove this conditional when we no longer need to support ES 0.90.x
  if $legacy_elasticsearch {
    $es_node_stats_url = "http://127.0.0.1:${es_port}/_cluster/nodes/_local/stats?http=true&process=true&jvm=true&transport=true"
  } else {
    $es_node_stats_url = "http://127.0.0.1:${es_port}/_nodes/_local/stats/indices,http,jvm,process,transport"
  }

  @collectd::plugin { 'elasticsearch':
    content => template('collectd/etc/collectd/conf.d/elasticsearch.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
