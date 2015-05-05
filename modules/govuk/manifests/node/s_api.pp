# == Class: govuk::node::s_api
#
class govuk::node::s_api inherits govuk::node::s_base {
  include nginx

  include govuk_postgresql::client

  include govuk::apps::backdrop_read
  include govuk::apps::backdrop_write
  include govuk::apps::metadata_api
  include govuk::apps::stagecraft
}
