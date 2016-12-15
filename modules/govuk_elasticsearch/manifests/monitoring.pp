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

  validate_bool($disable_gc_alerts)

  class { 'collectd::plugin::elasticsearch':
    es_port              => $http_port,
    log_index_type_count => $log_index_type_count,
  }

  unless $disable_gc_alerts {
    @@icinga::check::graphite { "check_elasticsearch_jvm_gc_old_collection_time_in_millis-${::hostname}":
      target    => "summarize(${::fqdn_metrics}.curl_json-elasticsearch.counter-jvm_gc_collectors_old_collection_time_in_millis,\"5minutes\",\"max\",true)",
      desc      => 'Prolonged GC collection times: old',
      warning   => 150,
      critical  => 300,
      host_name => $::fqdn,
      notes_url => monitoring_docs_url(prolonged-gc-collection-times-check),
    }
    @@icinga::check::graphite { "check_elasticsearch_jvm_gc_young_collection_time_in_millis-${::hostname}":
      target    => "summarize(${::fqdn_metrics}.curl_json-elasticsearch.counter-jvm_gc_collectors_young_collection_time_in_millis,\"5minutes\",\"max\",true)",
      desc      => 'Prolonged GC collection times: young',
      warning   => 150,
      critical  => 300,
      host_name => $::fqdn,
      notes_url => monitoring_docs_url(prolonged-gc-collection-times-check),
    }
  }

  @icinga::nrpe_config { 'check_elasticsearch_cluster_health':
    source => 'puppet:///modules/govuk_elasticsearch/check_elasticsearch_cluster_health.cfg',
  }

  # Check against the total number of hosts, not the minimum, else the alert
  # won't fire correctly
  @@icinga::check { "check_elasticsearch-${cluster_name}_cluster_health_running_on_${::hostname}":
    check_command       => "check_nrpe!check_elasticsearch_cluster_health!${host_count}",
    service_description => 'elasticsearch cluster is not healthy',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(elasticsearch-cluster-health),
  }
}
