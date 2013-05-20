class elms_base::frontend_server {
  include govuk::node::s_base
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps':
    require => Class['nginx']
  }
}
