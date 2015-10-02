# == Class: govuk::node::s_api
#
class govuk::node::s_api inherits govuk::node::s_base {
  include nginx

  include govuk::node::s_ruby_app_server

  include govuk_postgresql::client

  include govuk::apps::backdrop_read
  include govuk::apps::backdrop_write
  include govuk::apps::metadata_api
  include govuk::apps::stagecraft
  include govuk::apps::stagecraft::worker

  if $::hostname == 'api-1' {
    include govuk::apps::stagecraft::beat
    include govuk::apps::stagecraft::celerycam
  }
}
