# == Class: govuk_ci::agent
#
# Class to manage continuous deployment agents
#
# === Parameters:
#
# [*master_ssh_key*]
#   The public SSH key of the CI master to enable SSH based agent builds
#
# [*gdal_version*]
#   The version of the GDAL library to install for mapit
#
# [*geos_version*]
#   The version of the GEOS library to install for mapit
#
# [*proj_version*]
#   The version of the PROJ library to install for mapit
#
class govuk_ci::agent(
  $master_ssh_key = undef,
  $gemstash_server = 'http://gemstash.cluster',
  $gdal_version =  '2.4.4',
  $geos_version = '3.9.0',
  $proj_version = '4.9.3',
) {
  include ::govuk_java::openjdk8::jre
  include ::govuk_java::openjdk8::jdk
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk8',
    jre => 'openjdk8',
  }

  include ::clamav
  include ::clamav::cron_freshclam
  include ::govuk_ci::agent::redis
  include ::govuk_ci::agent::docker
  include ::golang
  include ::govuk_ci::agent::gcloud
  include ::govuk_ci::agent::memcached
  include ::govuk_ci::agent::mongodb
  include ::govuk_ci::agent::mysql
  include ::govuk_ci::agent::postgresql
  include ::govuk_ci::agent::rabbitmq
  include ::govuk_ci::agent::solr
  include ::govuk_ci::credentials
  include ::govuk_ci::limits
  include ::govuk_jenkins::packages::terraform
  include ::govuk_jenkins::packages::govuk_python
  include ::govuk_jenkins::pipeline
  include ::govuk_jenkins::user
  include ::govuk_rbenv::all
  include ::govuk_python
  include ::govuk_python3
  include ::govuk_sysdig
  include ::govuk_testing_tools
  include ::yarn

  include ::govuk_ci::agent::elasticsearch

  # Override sudoers.d resource (managed by sudo module) to enable Jenkins user to run sudo tests
  File<|title == '/etc/sudoers.d/'|> {
    mode => '0555',
  }

  file { '/var/lib/jenkins':
    owner => 'jenkins',
    group => 'jenkins',
  } ->
  file { '/var/lib/jenkins/.ssh':
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0700',
  } ->
  ssh_authorized_key { 'ci-master-1.ci':
    ensure  => present,
    user    => 'jenkins',
    type    => 'ssh-rsa',
    key     => $master_ssh_key,
    require => Class['::govuk_jenkins::user'],
  }

  $deb_packages = [
    'jq',
    'libfreetype6-dev', # govuk-taxonomy-supervised-learning
    'libhdf4-0-alt',
    'libnetcdf-dev',
    'shellcheck',
    'unixodbc-dev',
  ]

  $deb_absent_packages = [
    'libgdal-dev',
    'libgeos-c1',
    'libgeos-dev',
    'libproj-dev',
    'proj-bin',
    'proj-data',
  ]

  ensure_packages($deb_packages, {'ensure' => 'installed'})
  ensure_packages($deb_absent_packages, {'ensure' => 'absent'})

  include gdal::repo
  package { 'gdal':
    ensure  => $gdal_version,
    require => Class['gdal::repo'],
  }

  package { 'geos':
    ensure  => $geos_version,
    require => Apt::Source['postgis'],
  }

  package { 'proj':
    ensure  => $proj_version,
    require => Apt::Source['postgis'],
  }

  package { 's3cmd':
    ensure   => 'present',
    provider => 'pip',
  }

  govuk_bundler::config {'jenkins-bundler':
    server    => $gemstash_server,
    username  => 'jenkins',
    user_home => '/var/lib/jenkins',
  }
}
