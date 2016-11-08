# == Class: govuk_jenkins
#
# Configure a standalone instance of Jenkins with GitHub oAuth for
# deployment tasks (not CI).
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*github_enterprise_cert*]
#   PEM certificate for GitHub Enterprise.
#
# [*config*]
#   A hash of Jenkins config options to set
#
# [*plugins*]
#   A hash of Jenkins plugins that should be installed
#
class govuk_jenkins (
  $apt_mirror_hostname,
  $github_enterprise_cert,
  $github_enterprise_hostname,
  $jenkins_home,
  $github_enterprise_cert_path,
  $config = {},
  $plugins = {},
) {
  validate_hash($config, $plugins)

  include govuk_python
  include govuk_jenkins::job_builder
  include govuk_jenkins::ssh_key
  include govuk_jenkins::config

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
  file { $github_enterprise_cert_path:
    ensure  => file,
    content => $github_enterprise_cert,
  }

  java_ks { "${github_enterprise_hostname}:cacerts":
    ensure       => latest,
    certificate  => $github_enterprise_cert_path,
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

  package { 's3cmd':
    ensure   => 'present',
    provider => 'pip',
  }

  # Runtime dependency of: https://github.com/alphagov/search-analytics
  include libffi

  file { "${jenkins_home}/.gitconfig":
    source  => 'puppet:///modules/govuk_jenkins/dot-gitconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  apt::source { 'govuk-jenkins':
    location     => "http://${apt_mirror_hostname}/govuk-jenkins",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  class { 'jenkins':
    version            => '1.554.2',
    repo               => false,
    install_java       => false,
    configure_firewall => false,
    config_hash        => $config,
    manage_user        => false,
    manage_group       => false,
    plugin_hash        => $plugins,
    require            => Class['govuk_java::set_defaults'],
  }

  file { '/etc/default/jenkins':
    ensure => file,
    notify => Class['jenkins::service'],
  }

  include govuk_mysql::libdev
  include mysql::client
}
