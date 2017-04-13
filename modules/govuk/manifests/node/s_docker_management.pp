# == Class: govuk::node::s_docker_management
#
class govuk::node::s_docker_management inherits govuk::node::s_base {

  include ::govuk_docker
  include ::govuk_containers::docker_security_bench
  include ::govuk_containers::etcd

}
