class govuk::node::s_licensify_frontend inherits govuk::node::s_base {
  include clamav

  include govuk_java::oracle7::jdk

  class { 'nginx': }
  class { 'licensify::apps::licensify': }
}
