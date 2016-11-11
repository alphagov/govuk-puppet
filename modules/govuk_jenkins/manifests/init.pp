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
# [*github_enterprise_hostname*]
#   The hostname of Github Enterprise
#
# [*config*]
#   A hash of Jenkins config options to set
#
# [*plugins*]
#   A hash of Jenkins plugins that should be installed
#
# [*ssh_private_key*]
#   The SSH private key of the Jenkins user
#
# [*ssh_public_key*]
#   The SSH public key of the Jenkins user
#
class govuk_jenkins (
  $github_enterprise_cert,
  $github_enterprise_hostname,
  $github_enterprise_cert_path,
  $config = {},
  $plugins = {},
  $ssh_private_key = undef,
  $ssh_public_key = undef,
) {
  validate_hash($config, $plugins)

  include ::govuk_python
  include ::govuk_jenkins::config
  include ::govuk_jenkins::job_builder

  class { 'govuk_jenkins::user':
    private_key => $ssh_private_key,
    public_key  => $ssh_public_key,
  }

  class { 'govuk_jenkins::package':
    config  => $config,
    plugins => $plugins,
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

  include govuk_mysql::libdev
  include mysql::client
}
