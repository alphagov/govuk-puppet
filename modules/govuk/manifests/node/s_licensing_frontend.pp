# == Class: govuk::node::s_licensing_frontend
#
# Sets up app servers for the licensing frontend
#
class govuk::node::s_licensing_frontend inherits govuk::node::s_base {
  include clamav

  class { '::govuk_java::oracle':
    version => 8,
  }

  include licensify::apps::licensify
  include licensify::apps::licensing_web_forms

  include nginx
}
