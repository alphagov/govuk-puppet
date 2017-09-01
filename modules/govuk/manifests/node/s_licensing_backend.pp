# == Class: govuk::node::s_licensing_backend
#
# Sets up app servers for the licensing backend
#
class govuk::node::s_licensing_backend inherits govuk::node::s_base {
  include clamav

  class { '::govuk_java::oracle':
    version => 8,
  }

  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed

  include nginx
}
