# == Class: govuk_ci::agent
#
# Class to manage continuous deployment agents
#
# === Parameters:
#
# [*master_ssh_key*]
#   The public SSH key of the CI master to enable SSH based agent builds
#
# [*elasticsearch_enabled*]
#   Boolean.  Allows the exclusion of the elasticsearch class.
#
class govuk_ci::agent(
  $master_ssh_key = undef,
  $elasticsearch_enabled = true,
  $gemstash_server = 'http://gemstash.cluster',
) {
  include ::clamav
  include ::govuk_ci::agent::redis
  include ::govuk_ci::agent::docker
  if $elasticsearch_enabled {
    include ::govuk_ci::agent::elasticsearch
  }
  include ::golang
  include ::govuk_ci::agent::gcloud
  include ::govuk_ci::agent::mongodb
  include ::govuk_ci::agent::mysql
  include ::govuk_ci::agent::postgresql
  include ::govuk_ci::agent::rabbitmq
  include ::govuk_ci::credentials
  include ::govuk_ci::limits
  include ::govuk_ci::vpn
  include ::govuk_java::oracle8
  include ::govuk_jenkins::github_enterprise_cert
  include ::govuk_jenkins::packages::terraform
  include ::govuk_jenkins::pipeline
  include ::govuk_jenkins::user
  include ::govuk_rbenv::all
  include ::govuk_sysdig
  include ::govuk_testing_tools

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

  package { 'libgdal-dev': # needed for mapit
    ensure => installed,
  }

  govuk_bundler::config {'jenkins-bundler':
    server    => $gemstash_server,
    user_home => '/var/lib/jenkins',
  }
}
