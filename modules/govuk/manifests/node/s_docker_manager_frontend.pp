# == Class: govuk::node::s_docker_manager_frontend
#
# A Docker Swarm manager for frontend cluster
#
class govuk::node::s_docker_manager_frontend {

  include ::govuk::node::s_docker_base

  govuk_docker::swarm { "frontend_cluster_manager_${::hostname}":
    role         => 'manager',
    cluster_name => 'frontend_cluster',
    require      => Class['::govuk::node::s_docker_base'],
  }

}
