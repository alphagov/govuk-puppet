# == Class: collectd::plugin::etcd
#
# Collectd plugin for etcd using the cURL-JSON plugin.
#
# === Parameters
#
# [*client_endpoint*]
#   Determines the etcd client URL (typically on port 4001) to use when retrieving metrics.
#
# [*peer_endpoint*]
#   Determines the etcd peer URL (typically on port 7001) to use when retrieving metrics.
#
class collectd::plugin::etcd {
  include collectd::plugin::curl_json

  $client_endpoint = "${::fqdn}:4001"
  $peer_endpoint = "${::fqdn}:7001"

  @collectd::plugin { 'etcd':
    content => template('collectd/etc/collectd/conf.d/etcd.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
