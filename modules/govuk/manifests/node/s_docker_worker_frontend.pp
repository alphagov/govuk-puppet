# == Class: govuk::node::s_docker_worker_frontend
#
# A Docker Swarm worker for frontend cluster
#
class govuk::node::s_docker_worker_frontend {

  include ::govuk::node::s_docker_base

  govuk_docker::swarm { "frontend_cluster_worker_${::hostname}":
    role         => 'worker',
    cluster_name => 'frontend_cluster',
    require      => Class['::govuk::node::s_docker_base'],
  }

}
