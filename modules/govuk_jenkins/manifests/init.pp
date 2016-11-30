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
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret*]
#   The Github client secret is used to authenticate against Github.
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
# [*version*]
#   Specify the version of Jenkins
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
class govuk_jenkins (
  $github_enterprise_cert,
  $github_enterprise_hostname,
  $github_enterprise_cert_path,
  $github_client_id,
  $github_client_secret,
  $config = {},
  $plugins = {},
  $ssh_private_key = undef,
  $ssh_public_key = undef,
  $version = '1.554.2',
  $jenkins_api_token = '',
  $jenkins_user = 'jenkins',
  $jenkins_homedir = '/var/lib/jenkins',
  $environment_variables = {},
) {
  validate_hash($config, $plugins)

  include ::govuk_python

  class { 'govuk_jenkins::job_builder':
    jenkins_api_token => $jenkins_api_token,
  }

  class { 'govuk_jenkins::config':
    github_client_id      => $github_client_id,
    github_client_secret  => $github_client_secret,
    environment_variables => $environment_variables,
  }

  class { 'govuk_jenkins::package':
    config  => $config,
    plugins => $plugins,
  }

  class { 'govuk_jenkins::user':
    home_directory => $jenkins_homedir,
    username       => $jenkins_user,
  }

  class { 'govuk_jenkins::ssh_key':
    private_key  => $ssh_private_key,
    public_key   => $ssh_public_key,
    jenkins_user => $jenkins_user,
    home_dir     => $jenkins_homedir,
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
