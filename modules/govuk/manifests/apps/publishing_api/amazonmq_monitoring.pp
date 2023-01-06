# define monitor_queue {
#   @@icinga::check { "check_amazonmq_consumers_for_${name}_on_${::hostname}":
#     check_command       => "check_nrpe!check_amazonmq_consumers!PublishingMQ publishing ${name}",
#     service_description => "Check that there has been at least one consumer in the last 5 minutes for publishing AmazonMQ queue ${name}",
#     host_name           => $::fqdn,
#     notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
#   }
# }

# = govuk::apps::publishing_api::amazonmq_monitoring
#
# The PublishingMQ is owned by Publishing API, therefore that's where the
# monitoring of queue consumers is done.
#
# [*broker_name*]
# [*queues_to_monitor*]
# The queues to monitor, defined as an array of hashes. Each hash must contain
# virtual_host and queue
#
# [*ensure*]
#   Whether the monitoring should be created
#
class govuk::apps::publishing_api::amazonmq_monitoring (
  $broker_name,
  $queues_to_monitor = [],
  $ensure = present,
) {

  # class { 'collectd::plugin::elasticsearch':
  #   es_host  => $es_host,
  #   es_port  => $es_port,
  #   node_id  => '*',
  #   template => 'collectd/etc/collectd/conf.d/elasticsearch-aws.conf.erb',
  # }

  # @icinga::plugin { 'check_elasticsearch_aws_cluster_health':
  #   source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_elasticsearch_aws',
  # }

  # @icinga::nrpe_config { 'check_elasticsearch_aws_cluster_health':
  #   source  => 'puppet:///modules/govuk_search/check_elasticsearch_aws_cluster_health.cfg',
  #   require => Icinga::Plugin['check_elasticsearch_aws_cluster_health'],
  # }


  if $ensure == present {
    include icinga::plugin::check_amazonmq_consumers

    @@icinga::check { "check_amazonmq_consumers_for_search_api_to_be_indexed_on_${::hostname}":
      check_command       => "check_nrpe!check_amazonmq_consumers!PublishingMQ publishing search_api_to_be_indexed",
      service_description => "Check that there has been at least one consumer in the last 5 minutes for publishing AmazonMQ queue search_api_to_be_indexed",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
    }
  }

}
