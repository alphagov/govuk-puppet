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

  @icinga::plugin { 'check_elasticsearch_aws_cluster_health':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_elasticsearch_aws',
  }

  @icinga::nrpe_config { 'check_elasticsearch_aws_cluster_health':
    source  => 'puppet:///modules/govuk_search/check_elasticsearch_aws_cluster_health.cfg',
    require => Icinga::Plugin['check_elasticsearch_aws_cluster_health'],
  }

}
