# == Class: collectd::plugin::etcd
#
# Collectd plugin for etcd using the cURL-JSON plugin.
#
class collectd::plugin::etcd {
  include collectd::plugin::curl_json

  $client_endpoint = "${::fqdn}:2379"
  $peer_endpoint = "${::fqdn}:2380"

  @collectd::plugin { 'etcd':
    content => template('collectd/etc/collectd/conf.d/etcd.conf.erb'),
    require => Class['collectd::plugin::curl_json'],
  }
}
