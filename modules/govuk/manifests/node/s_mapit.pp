# == Class: govuk::node::s_mapit
#
class govuk::node::s_mapit inherits govuk::node::s_base {

  include govuk_python3
  include nginx

  # Make sure virtualenv is installed for Python 3.6 as required by mapit
  exec { 'check_virtualenv_for_python_3_6':
    path    => ['/usr/bin', '/usr/sbin'],
    command => '/usr/bin/pip3.6 install -I virtualenv==20.4.7',
    require => [Class['govuk_python3'], Class['govuk_python']],
    unless  => 'test -d /usr/lib/python3.6/site-packages/virtualenv',
  }

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

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
