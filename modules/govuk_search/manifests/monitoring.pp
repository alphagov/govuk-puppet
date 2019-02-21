# == Class govuk_search::monitoring
#
# Setup monitoring for a remote Elasticsearch cluster
#
class govuk_search::monitoring (
  $es_host = 'localhost',
  $es_port = '9200'
) {

  class { 'collectd::plugin::elasticsearch':
    es_host  => $es_host,
    es_port  => $es_port,
    node_id  => '*',
    template => 'collectd/etc/collectd/conf.d/elasticsearch-aws.conf.erb',
  }

}
