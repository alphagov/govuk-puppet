# == Class: govuk::node::s_gatling
#
# This machine class is used to run Gatling, a load testing tool.
#
# === Parameters
#
# [*root_dir*]
#  The root of the website where Gatling stores its results
#  Default = '/home/gatling/gatling-software/results'
#
# [*repo*]
#  The github repository where GOV.UK defines its load tests
#  Default = 'git@github.com:alphagov/govuk-load-testing.git'
#
# [*commit*]
#  The version of the repository where GOV.UK defines its load tests
#  Default = 'master'
#
#
#
class govuk::node::s_gatling (
  $root_dir            = '/usr/local/bin/gatling/results',
  $repo                = 'https://github.com/alphagov/govuk-load-testing.git',
  $commit              = 'master',
  $apt_mirror_hostname = undef,
) inherits govuk::node::s_base {

  # User used to run Gatling
  govuk_user { 'gatling':
    fullname => 'GOV.UK Gatling',
    email    => 'webops@digital.cabinet-office.gov.uk',
    groups   => ['admin', 'deploy', 'adm', 'www-data' ],
  }

  # repository where GOV.UK stores its load tests
  vcsrepo { '/home/gatling/govuk-load-testing':
    ensure   => present,
    provider => git,
    source   => $repo,
    revision => $commit,
    force    => true,
  }

  # install the JRE and JDK on the Gatling instance
  include ::govuk_java::openjdk8::jre
  include ::govuk_java::openjdk8::jdk
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk8',
    jre => 'openjdk8',
  }

  apt::source { 'govuk-gatling':
    location     => "http://${apt_mirror_hostname}/govuk-gatling",
    release      => 'trusty',
    architecture => $::architecture,
    repos        => 'main',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'govuk-gatling':
    ensure  => latest,
    name    => 'gatling-3.1.3.deb',
    require => Apt::Source['govuk-gatling'],
  }

  file { '/usr/local/bin/gatling':
    ensure  => directory,
    mode    => '0777',
    recurse => true,
    require => Package['govuk-gatling'],
  }

  include nginx
  nginx::config::site { 'gatling_service':
    content => template('govuk/node/s_gatling/gatling_cluster_vhost.conf.erb'),
  }
}
