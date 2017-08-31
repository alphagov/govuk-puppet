# == Class: govuk::node::s_mapit
#
class govuk::node::s_mapit inherits govuk::node::s_base {

  include nginx
  include ::govuk_postgresql::server::standalone

  if ! $::aws_migration {
    Govuk_mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server::standalone']
  }

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
