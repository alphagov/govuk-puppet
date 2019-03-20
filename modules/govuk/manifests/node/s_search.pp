# == Class govuk::node::s_search
#
# Machines for running the search applications (initially rummager) in the api vDC
#
class govuk::node::s_search inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include govuk_aws_xray_daemon

  include govuk_search::gor

  include govuk_search::monitoring

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Data sync for managed elasticsearch
  if $::aws_migration {
    include govuk_env_sync
  }

  # Local proxy for Rummager to access ES cluster.
  if ! $::aws_migration {
    include govuk_elasticsearch::local_proxy
  }
}
