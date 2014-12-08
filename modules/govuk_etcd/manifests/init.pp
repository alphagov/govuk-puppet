# == Class: govuk_etcd
#
# A thin wrapper around the upstream etcd module.
#
# Ensures that the first node in the etcd cluster receives an empty peer list
# so that the cluster can bootstrap itself on first run.
#
# === Parameters
#
# [*peers*]
#   An array specifying the hostname and port of each node in the cluster.
#   Syntax is the same as for $::etcd::peers.
#   Mandatory as we always need to define the peers.
#
class govuk_etcd ($peers) {
  # Set empty peer list for first node to allow cluster to bootstrap
  $first_peer_parsed = split($peers[0], '[.]')
  $first_peer_hostname = $first_peer_parsed[0]

  if $::hostname == $first_peer_hostname {
    $actual_peers = []
  } else {
    $actual_peers = $peers
  }

  class { 'etcd':
    peers => $actual_peers
  }
}
