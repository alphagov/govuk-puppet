# == Class: govuk_jenkins
#
# Configure a standalone instance of Jenkins with GitHub oAuth for
# deployment tasks (not CI).
#
# === Parameters:
#
# [*github_enterprise_cert*]
#   PEM certificate for GitHub Enterprise.
#
class govuk_jenkins (
  $github_enterprise_cert,
) {
  include govuk::python
  include govuk_jenkins::job_builder
  include govuk_jenkins::ssh_key

  $jenkins_home = '/var/lib/jenkins'
  $github_enterprise_hostname = 'github.gds'
  $github_enterprise_filename = "${jenkins_home}/${github_enterprise_hostname}.pem"

  user { 'jenkins':
    ensure     => present,
    home       => $jenkins_home,
    managehome => true,
    shell      => '/bin/bash',
  }

  include govuk_java::openjdk7::jdk
  include govuk_java::openjdk7::jre

  class { 'govuk_java::set_defaults':
    jdk     => 'openjdk7',
    jre     => 'openjdk7',
    require => [
                  Class['govuk_java::openjdk7::jdk'],
                  Class['govuk_java::openjdk7::jre'],
                ],
    notify  => Class['jenkins::service'],
  }

  # In addition to the keystore below, this path is also referenced by the
  # `GITHUB_GDS_CA_BUNDLE` environment variable in Jenkins which is used by
  # ghtools during GitHub.com -> GitHub Enterprise repo backups.
  file { $github_enterprise_filename:
    ensure  => file,
    content => $github_enterprise_cert,
  }

  java_ks { "${$github_enterprise_hostname}:cacerts":
    ensure       => latest,
    certificate  => $github_enterprise_filename,
    target       => '/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/cacerts',
    password     => 'changeit',
    trustcacerts => true,
    notify       => Class['jenkins::service'],
    require      => Class['govuk_java::openjdk7::jre'],
  }

  package { 'ghtools':
    ensure   => '0.20.0',
    provider => pip,
  }

  package { 'brakeman':
    ensure   => 'installed',
    provider => system_gem,
  }

  # Runtime dependency of: https://github.com/alphagov/search-analytics
  package { 'libffi-dev':
    ensure => present,
  }

  file { "${jenkins_home}/.gitconfig":
    source  => 'puppet:///modules/govuk_jenkins/dot-gitconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  apt::source { 'jenkins':
    location     => 'http://apt.production.alphagov.co.uk/jenkins',
    release      => 'binary',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }

  class { 'jenkins':
    version            => '1.554.2',
    repo               => false,
    install_java       => false,
    configure_firewall => false,
    plugin_hash        => {
      'ansicolor'              => { 'version' => '0.3.1' },
      'build-name-setter'      => { 'version' => '1.3' },
      'build-pipeline-plugin'  => { 'version' => '1.4.5' },
      'build-with-parameters'  => { 'version' => '1.3' },
      'conditional-buildstep'  => { 'version' => '1.3.3' },
      'copyartifact'           => { 'version' => '1.35' },
      'description-setter'     => { 'version' => '1.9' },
      'downstream-buildview'   => { 'version' => '1.9' },
      'envinject'              => { 'version' => '1.91.1' },
      'external-monitor-job'   => { 'version' => '1.2' },
      'git'                    => { 'version' => '2.2.6' },
      'git-client'             => { 'version' => '1.10.2' },
      'github-api'             => { 'version' => '1.58' },
      'github-oauth'           => { 'version' => '0.19' },
      'gradle'                 => { 'version' => '1.24' },
      'greenballs'             => { 'version' => '1.14' },
      'groovy-postbuild'       => { 'version' => '2.2' },
      'instant-messaging'      => { 'version' => '1.33' },
      'ircbot'                 => { 'version' => '2.26' },
      'jquery'                 => { 'version' => '1.7.2-1' },
      'nodelabelparameter'     => { 'version' => '1.5.1' },
      'parameterized-trigger'  => { 'version' => '2.26' },
      'rake'                   => { 'version' => '1.8.0' },
      'rebuild'                => { 'version' => '1.22' },
      'role-strategy'          => { 'version' => '2.2.0' },
      'run-condition'          => { 'version' => '1.0' },
      'sbt'                    => { 'version' => '1.5' },
      'scm-api'                => { 'version' => '0.2' },
      'scm-sync-configuration' => { 'version' => '0.0.8' },
      'show-build-parameters'  => { 'version' => '1.0' },
      'versionnumber'          => { 'version' => '1.5' },
      'ws-cleanup'             => { 'version' => '0.25' },
    },
    require            => Class['govuk_java::set_defaults'],
  }

  # FIXME: Replace with `config_hash` param to set `sessionTimeout`.
  file { '/etc/default/jenkins':
    ensure => file,
    source => 'puppet:///modules/govuk_jenkins/etc/default/jenkins',
    notify => Class['jenkins::service'],
  }

  include govuk_mysql::libdev
  include mysql::client
}
