# == Class: govuk::node::s_ckan
#
# Backend machine definition. Backend machines are used for running
# publishing, administration and management applications.
#
class govuk::node::s_ckan inherits govuk::node::s_base {
  limits::limits { 'root_nofile':
    ensure     => present,
    user       => 'root',
    limit_type => 'nofile',
    both       => 16384,
  }

  limits::limits { 'root_nproc':
    ensure     => present,
    user       => 'root',
    limit_type => 'nproc',
    both       => 1024,
  }

  include govuk_python
  include nginx
  include postgresql::lib::devel
  include govuk_java::openjdk8::jre
  include govuk_java::openjdk8::jdk
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk8',
    jre => 'openjdk8',
  }
  include govuk_solr
  include govuk_solr6

  package { 'libgeos-c1':
    ensure => latest,
  }
}
