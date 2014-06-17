class govuk::node::s_licensify_backend (
  $enable_licensing_api = false
) inherits govuk::node::s_base {
  include clamav

  include govuk_java::oracle7::jdk

  class { 'nginx': }
  class { 'licensify::apps::licensify_admin': }
  class { 'licensify::apps::licensify_feed': }
  if ($enable_licensing_api) {
    class { 'licensify::apps::licensing_api': }
  }
}
