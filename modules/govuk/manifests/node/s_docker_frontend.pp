# == Class: govuk::node::s_docker_frontend
#
# === Parameters
#
# [*enable_memcache*]
#   Whether to install memcached
#
class govuk::node::s_docker_frontend(
  $enable_memcache = false,
) {

  include ::govuk::node::s_base
  include ::govuk_docker

  if $enable_memcache {
    include ::govuk_containers::memcached
  }

}
