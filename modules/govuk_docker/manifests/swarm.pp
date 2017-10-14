# == Define: Govuk_docker::Swarm
#
# Manage a Docker Swarm
#
# === Parameters:
#
# [*role*]
#   The role of the node. Either "worker" or "manager".
#
# [*ensure*]
#   Whether to set everything up.
#
# [*etcd_endpoints]
#   An array of etcd_endpoints
#
# [*cluster_name*]
#   Name of the cluster. This only affects where the values are stored in
#   etcd.
#
define govuk_docker::swarm (
  $role,
  $ensure = 'present',
  $etcd_endpoints = [],
  $cluster_name = 'default_cluster',
){
  include ::govuk_docker
  validate_re($role, [ 'worker', 'manager' ])

  package { 'etcdctl':
    ensure => $ensure,
  }

  file { "/usr/local/bin/swarm_${role}":
    ensure  => $ensure,
    mode    => '0775',
    content => template("govuk_docker/swarm_${role}.erb"),
    require => Package['etcdctl'],
  }

  cron::crondotdee { "docker_swarm_${role}_${::hostname}":
    ensure  => $ensure,
    command => "/usr/local/bin/swarm_${role} $cluster_name",
    hour    => '*',
    minute  => '*/2',
    require => File["/usr/local/bin/swarm_${role}"],
  }
}
