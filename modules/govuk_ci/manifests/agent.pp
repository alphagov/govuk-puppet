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
class govuk_ci::agent(
  $master_ssh_key = undef,
  $gemstash_server = 'http://gemstash.cluster',
  $gdal_version,
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
  include ::govuk_ci::agent::mongodb
  include ::govuk_python
  include ::govuk_ci::agent::mysql
  include ::govuk_ci::agent::postgresql
  include ::govuk_ci::agent::rabbitmq
  include ::govuk_ci::agent::solr
  include ::govuk_ci::credentials
  include ::govuk_ci::limits
  include ::govuk_jenkins::packages::terraform
  include ::govuk_jenkins::packages::terraform_docs
  include ::govuk_python
  include ::govuk_jenkins::packages::vale
  include ::govuk_jenkins::pipeline
  include ::govuk_jenkins::user
  include ::govuk_rbenv::all
  include ::govuk_sysdig
  include ::govuk_testing_tools
  include ::yarn

  include ::govuk_ci::agent::elasticsearch

  # Override sudoers.d resource (managed by sudo module) to enable Jenkins user to run sudo tests
  File<|title == '/etc/sudoers.d/'|> {
    mode => '0555',
  }

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
    'python3-dev', # govuk-taxonomy-supervised-learning
    'shellcheck',
  ]

  ensure_packages($deb_packages, {'ensure' => 'installed'})
  ensure_packages(['libgdal-dev'], {'ensure' => 'absent'})

  include gdal::repo
  package { 'gdal':
    ensure  => $gdal_version,
    require => Class['gdal::repo'],
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
