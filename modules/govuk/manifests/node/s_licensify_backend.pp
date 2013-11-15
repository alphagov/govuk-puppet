class govuk::node::s_licensify_backend inherits govuk::node::s_base {
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps::licensify_admin': }
  class { 'licensify::apps::licensify_feed': }
  class { 'licensify::apps::licensing_api': }
}
