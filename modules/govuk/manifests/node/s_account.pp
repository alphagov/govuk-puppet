# == Class: govuk::node::s_account
#
# Account machine definition. Accounts machines are used for running
# the Account API application which implements authentication and
# attribute storage.
#
class govuk::node::s_account inherits govuk::node::s_base {

  include govuk::node::s_app_server

  include nginx

  # The catchall vhost throws a 500, except for healthcheck requests.
  nginx::config::vhost::default { 'default': }

  govuk_envvar {
    'UNICORN_TIMEOUT': value => 15;
  }
}
