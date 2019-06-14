# == Class: govuk_ci::agent::memcached
#
# Installs and configures memcached
#
class govuk_ci::agent::memcached {
  include ::govuk_docker
  include ::govuk_containers::memcached
}
