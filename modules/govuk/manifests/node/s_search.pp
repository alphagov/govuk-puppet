# == Class govuk::node::s_search
#
# Machines for running the search applications (initially rummager) in the api vDC
#
class govuk::node::s_search inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Local proxy for Rummager to access ES cluster.
  if ! $::aws_migration {
    include govuk_elasticsearch::local_proxy
  }
}
