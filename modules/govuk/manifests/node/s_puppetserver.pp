# == Class: govuk::node::s_puppetmaster
#
class govuk::node::s_puppetserver inherits govuk::node::s_base {
  include govuk_postgresql::backup

  include ::govuk_docker
  include ::govuk_containers::puppetdb_postgres
  include ::govuk_containers::puppetdb
  include ::govuk_containers::puppetserver

  docker_network { 'docker_gwbridge':
    ensure  => present,
    driver  => 'bridge',
    subnet  => '172.30.0.0/16',
    options => [
      'com.docker.network.bridge.name=docker_gwbridge',
      'com.docker.network.bridge.enable_icc=true',
    ],
    require => Class['govuk_docker'],
  }

  Class['govuk_containers::puppetserver'] ->
  Class['govuk_containers::puppetdb_postgres'] ->
  Class['govuk_containers::puppetdb']

  file { '/var/lib/govuk_containers':
    ensure => directory,
    group  => 'docker',
  }

  @ufw::allow { 'allow-puppetserver-from-all':
    port => 8140,
  }

  @ufw::allow { 'allow-puppetdb-from-all':
    port => 8080,
  }
}
