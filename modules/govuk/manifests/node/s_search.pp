# == Class govuk::node::s_search
#
# Machines for running the search applications (initially rummager) in the api vDC
#
class govuk::node::s_search inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include govuk_search::monitoring

  include govuk_search::prune

  include nginx

  # The catchall vhost throws a 500, except for healthcheck requests.
  nginx::config::vhost::default { 'default': }

  # Data sync for managed elasticsearch
  if $::aws_migration {
    include govuk_env_sync
  }
}
