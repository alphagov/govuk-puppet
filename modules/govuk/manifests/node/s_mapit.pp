# == Class: govuk::node::s_mapit
#
class govuk::node::s_mapit inherits govuk::node::s_base {

  include nginx

  file { '/etc/postgresql':
    ensure  => directory,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0755',
    recurse => true,
    require => Class['postgresql::server::install'],
    before  => Class['postgresql::server::service'],
  }

  Govuk_mount['/var/lib/postgresql']
  ->
  class { 'govuk_postgresql::server::standalone': }

  include govuk_python

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
