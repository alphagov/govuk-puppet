class govuk::node::s_licensify_frontend inherits govuk::node::s_base {
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps::licensify': }
}
