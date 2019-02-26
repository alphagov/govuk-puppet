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

  include govuk_env_sync
  include govuk_python
  include nginx
  include postgresql::lib::devel
  include govuk_java::openjdk7::jdk
  include govuk_solr
  include govuk_postgresql::client

  package { 'libgeos-c1':
    ensure => latest,
  }
}
