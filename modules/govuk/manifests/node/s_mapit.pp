# == Class: govuk::node::s_mapit
#
class govuk::node::s_mapit inherits govuk::node::s_base {

  include nginx

  Govuk_mount['/var/lib/postgresql']
  ->
  class { 'govuk_postgresql::server::standalone': }

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
