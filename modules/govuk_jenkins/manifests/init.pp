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
  include govuk_jenkins::ssh_key

  $jenkins_home = '/var/lib/jenkins'
  $github_enterprise_hostname = 'github.gds'
  $github_enterprise_filename = "${jenkins_home}/${github_enterprise_hostname}.pem"

  # FIXME: Remove when deployed.
  exec { 'restore_default_jenkins_homedir':
    command => 'service jenkins stop; pkill -u jenkins; sleep 5; usermod -d /var/lib/jenkins jenkins',
    unless  => 'awk -F: \'$1 == "jenkins" && $6 != "/var/lib/jenkins" { exit(1) }\' /etc/passwd',
    notify  => Class['jenkins::service'],
  }

  user { 'jenkins':
    ensure     => present,
    home       => $jenkins_home,
    managehome => true,
    shell      => '/bin/bash',
    require    => Exec['restore_default_jenkins_homedir'],
  }

  include govuk_java::oracle7::jdk
  include govuk_java::oracle7::jre

  class { 'govuk_java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  file { $github_enterprise_filename:
    ensure  => file,
    content => $github_enterprise_cert,
  }

  java_ks { "${$github_enterprise_hostname}:cacerts":
    ensure       => latest,
    certificate  => $github_enterprise_filename,
    target       => '/usr/lib/jvm/java-7-oracle/jre/lib/security/cacerts',
    password     => 'changeit',
    trustcacerts => true,
    notify       => Class['jenkins::service'],
    require      => Class['govuk_java::oracle7::jre'],
  }

  package { 'brakeman':
    ensure   => 'installed',
    provider => system_gem,
  }

  file { "${jenkins_home}/.gitconfig":
    source  => 'puppet:///modules/govuk_jenkins/dot-gitconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  # FIXME: Remove when deployed.
  exec { 'restore_default_jenkins_datadir':
    command => 'service jenkins stop; rm /var/lib/jenkins; mv /mnt/jenkins /var/lib/jenkins',
    onlyif  => '/usr/bin/test -L /var/lib/jenkins',
    notify  => Class['jenkins::service'],
  }
  # FIXME: Remove when deployed.
  file { '/mnt/jenkins':
    ensure  => absent,
    force   => true,
    require => Exec['restore_default_jenkins_datadir'],
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
      'scm-api'       => { 'version' => '0.2' },
      'git'           => { 'version' => '2.2.6' },
      'git-client'    => { 'version' => '1.10.2' },
      'github-api'    => { 'version' => '1.58' },
      'github-oauth'  => { 'version' => '0.19' },
      'role-strategy' => { 'version' => '2.2.0' },
    },
    require            => Class['govuk_java::set_defaults'],
  }

  # FIXME: Replace with `config_hash` param to set `sessionTimeout`.
  file { '/etc/default/jenkins':
    ensure => file,
    source => 'puppet:///modules/govuk_jenkins/etc/default/jenkins',
    notify => Class['jenkins::service'],
  }

  include bundler
  include govuk_mysql::libdev
  include mysql::client

  # FIXME: Remove when deployed.
  package { [
    'libffi-dev',
    'aspell',
    'ant',
    'sqlite3',
    'gnuplot',
    'python-paramiko',
    'libtext-csv-perl',
    'libtext-csv-xs-perl',
    'libcrypt-ssleay-perl',
    'liburi-perl',
    'libwww-perl',
  ]:
    ensure   => absent,
  }

  # FIXME: Remove when deployed.
  package { [
    's3cmd',
    'ghtools',
    'scrapy',
    'twisted',
    'w3lib',
    'pyOpenSSL',
    'lxml',
    'zope.interface',
    'six',
    'cryptography',
    'cffi',
    'pycparser',
  ]:
    ensure   => absent,
    provider => pip,
  }

  # FIXME: Remove when deployed.
  file { '/var/govuk-archive':
    ensure => absent,
    force  => true,
  }
}
