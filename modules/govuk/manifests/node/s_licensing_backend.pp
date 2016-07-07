# == Class: govuk::node::s_licensing_backend
#
# Sets up app servers for the licensing backend
#
class govuk::node::s_licensing_backend inherits govuk::node::s_base {
  include clamav

  include govuk_java::oracle8

  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed

  include nginx
}
