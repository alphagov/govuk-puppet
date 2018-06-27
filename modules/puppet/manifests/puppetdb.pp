# == Class: puppet::puppetdb
#
# Installs and configures PuppetDB
#
# === Parameters
#
# [*database_password*]
#   The password of the PostgreSQL database
#   This is used both to create the database and to configure PuppetDB.
#
class puppet::puppetdb (
  $database_password,
)
{
  include '::puppet::repository'
  include '::govuk_postgresql::server::standalone'
  include '::govuk_postgresql::backup'

  $java_args = '-Xmx2048m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/puppetdb/puppetdb-oom.hprof -Djava.security.egd=file:/dev/urandom'

  govuk_postgresql::db { 'puppetdb':
    user     => 'puppetdb',
    password => $database_password,
    encoding => 'SQL_ASCII',
    before   => Service['puppetdb'],
  }

  govuk_postgresql::extension { 'puppetdb:pg_trgm':
    require => Govuk_postgresql::Db['puppetdb'],
    before  => Service['puppetdb'],
  }

  package { ['puppetdb', 'puppetdb-terminus']:
    ensure  => 'present',
    require => Class['::govuk_java::openjdk7::jre'],
  }

  exec { 'puppetdb ssl-setup':
    command => shellquote(['/usr/sbin/puppetdb', 'ssl-setup']),
    creates => '/etc/puppetdb/ssl/ca.pem',
    require => [
      Package['puppetdb'],
      Class['::puppet::puppetserver::generate_cert'],
    ],
    notify  => Service['puppetdb'],
  }

  file_line { 'default_puppetdb':
    ensure  => present,
    path    => '/etc/default/puppetdb',
    line    => sprintf('JAVA_ARGS="%s"\n', $java_args),
    match   => '^JAVA_ARGS=',
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  file { '/etc/puppetdb/conf.d/database.ini':
    ensure  => 'present',
    content => template('puppet/puppetdb/database.ini.erb'),
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  file { '/etc/puppetdb/repl.ini':
    ensure  => 'present',
    content => file('puppet/puppetdb/repl.ini'),
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  service { 'puppetdb':
    ensure => 'running',
    enable => true,
  }

  @logrotate::conf { 'puppetdb':
    matches => '/var/log/puppetdb/*.log',
  }
}

