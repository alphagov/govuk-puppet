# == Class: govuk::node::s_router_backend
#
# router backend node
#
class govuk::node::s_router_backend inherits govuk::node::s_base {
  include mongodb::server
  include govuk_env_sync
  include govuk::node::s_app_server

  include nginx

  # If we miss all the apps, throw a 400 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
