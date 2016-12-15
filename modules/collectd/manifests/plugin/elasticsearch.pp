# == Class: collectd::plugin::elasticsearch
#
# Setup collectd plugin to monitor an elasticsearch node
#
# === Parameters
#
# [*es_port*]
#   The port that the Elasticsearch HTTP interface is available on.
#
# [*log_index_type_count*]
#   A hash where the keys represent Elasticsearch indices and the values
#   are arrays of Elasticsearch types for that index.
#
class collectd::plugin::elasticsearch(
  $es_port,
  $log_index_type_count = {},
) {
  include collectd::plugin::curl_json

  $es_node_stats_url = "http://127.0.0.1:${es_port}/_nodes/_local/stats/indices,http,jvm,process,transport"

  @collectd::plugin { 'elasticsearch':
    content => template('collectd/etc/collectd/conf.d/elasticsearch.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
