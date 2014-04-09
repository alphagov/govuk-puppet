class govuk::node::s_licensify_backend inherits govuk::node::s_base {
  include clamav

  include govuk_java::oracle7::jdk

  class { 'nginx': }
  class { 'licensify::apps::licensify_admin': }
  class { 'licensify::apps::licensify_feed': }
  if str2bool(extlookup('govuk_enable_licensing_api','no')) {
    class { 'licensify::apps::licensing_api': }
  }
}
