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
# [*legacy*]
#   If set to true, use PuppetDB version 1.3.2-1puppetlabs1
#   Should only be set by puppet::master
#
class puppet::puppetdb (
  $database_password,
  $legacy = false,
)
{
  include '::puppet::repository'
  include '::govuk_postgresql::server::standalone'
  include '::govuk_postgresql::backup'

  require '::govuk_java::openjdk7::jre'

  if $legacy {
    # Activate legacy options for PuppetDB 1.x
    $package_ensure             = '1.3.2-1puppetlabs1'
    $java_args                  = '-Xmx1024m'
    $puppetdb_ssl_setup_command = '/usr/sbin/puppetdb-ssl-setup'
    $puppetdb_ssl_setup_creates = '/etc/puppetdb/ssl/keystore.jks'
    $configfile                 = 'config.ini.legacy'
    $cert_generation_class      = '::puppet::master::generate_cert'

    exec { 'disable-default-puppetdb':
      command => '/etc/init.d/puppetdb stop && /bin/rm /etc/init.d/puppetdb && /usr/sbin/update-rc.d puppetdb remove',
      unless  => '/usr/bin/test ! -e /etc/init.d/puppetdb',
      require => Package['puppetdb'],
      before  => Service['puppetdb'],
    }

    file { '/etc/init/puppetdb.conf':
      ensure  => 'present',
      content => template('puppet/puppetdb/upstart.conf.erb'),
      before  => Service['puppetdb'],
    }
  }
  else {
    $package_ensure             = 'present'
    $java_args                  = '-Xmx2048m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/puppetdb/puppetdb-oom.hprof -Djava.security.egd=file:/dev/urandom'
    $puppetdb_ssl_setup_command = shellquote(['/usr/sbin/puppetdb', 'ssl-setup'])
    $puppetdb_ssl_setup_creates = '/etc/puppetdb/ssl/ca.pem'
    $configfile                 = 'config.ini'
    $cert_generation_class      = '::puppet::puppetserver::generate_cert'
  }

  govuk_postgresql::db { 'puppetdb':
    user                => 'puppetdb',
    password            => $database_password,
    encoding            => 'SQL_ASCII',
    enable_in_pgbouncer => false,
    before              => Service['puppetdb'],
  }

  govuk_postgresql::extension { 'puppetdb:pg_trgm':
    require => Govuk_postgresql::Db['puppetdb'],
    before  => Service['puppetdb'],
  }

  package { ['puppetdb', 'puppetdb-terminus']:
    ensure  => $package_ensure,
  }

  exec { 'puppetdb ssl-setup':
    command => $puppetdb_ssl_setup_command,
    creates => $puppetdb_ssl_setup_creates,
    require => [
      Package['puppetdb'],
      Class[$cert_generation_class],
    ],
    notify  => Service['puppetdb'],
  }

  file_line { 'initd_puppetdb':
    ensure  => present,
    path    => '/etc/init.d/puppetdb',
    line    => "\t-XX:OnOutOfMemoryError='kill -9 %p; /etc/init.d/puppetdb restart; /etc/init.d/puppetserver restart' \$JAVA_ARGS \\",
    match   => '-XX:OnOutOfMemoryError=',
    require => Package['puppetdb'],
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

  file { '/etc/puppetdb/conf.d/config.ini':
    ensure  => 'present',
    content => file("puppet/puppetdb/${configfile}"),
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  file { '/etc/puppetdb/conf.d/database.ini':
    ensure  => 'present',
    content => template('puppet/puppetdb/database.ini.erb'),
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  file { '/etc/puppetdb/conf.d/repl.ini':
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
