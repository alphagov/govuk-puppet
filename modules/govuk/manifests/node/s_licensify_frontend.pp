class govuk::node::s_licensify_frontend inherits govuk::node::s_base {
  include clamav

  if hiera(licensify_use_java_7, false) {
    include java::oracle7::jdk
    }
  else {
    include java::openjdk6::jre
  }

  class { 'nginx': }
  class { 'licensify::apps::licensify': }
}
