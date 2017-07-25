# == Class: govuk_jenkins
#
# Configure a standalone instance of Jenkins with GitHub oAuth for
# deployment tasks (not CI).
#
# === Parameters:
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
# [*jenkins_api_user*]
#   An API user that authenticates with the Jenkins API.
#
# [*jenkins_api_token*]
#   A token to authenticate with the Jenkins API.
#
# [*jenkins_user*]
#   User that runs the Jenkins service.
#
# [*jenkins_homedir*]
#   Directory that Jenkins is installed into.
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
class govuk_jenkins (
  $github_client_id,
  $github_client_secret,
  $config = {},
  $plugins = {},
  $ssh_private_key = undef,
  $ssh_public_key = undef,
  $version = '2.46.2',
  $jenkins_api_user = 'jenkins_api_user',
  $jenkins_api_token = '',
  $jenkins_user = 'jenkins',
  $jenkins_homedir = '/var/lib/jenkins',
  $environment_variables = {},
) {
  validate_hash($config, $plugins)

  include ::govuk_python

  file { "${jenkins_homedir}/workspace":
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  class { 'govuk_jenkins::job_builder':
    jenkins_api_user  => $jenkins_api_user,
    jenkins_api_token => $jenkins_api_token,
  }

  class { 'govuk_jenkins::cli':
    jenkins_api_user  => $jenkins_api_user,
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

  include ::govuk_jenkins::github_enterprise_cert
  include ::govuk_jenkins::reload

  # Jenkins service needs to be restarted to reload the Java keystore
  Class['govuk_jenkins::github_enterprise_cert'] ~> Class['jenkins::service']

  package { 'ghtools':
    ensure   => '0.20.0',
    provider => pip,
  }

  package { 's3cmd':
    ensure   => 'present',
    provider => 'pip',
  }

  # Runtime dependency of: https://github.com/alphagov/search-analytics
  include libffi

  include govuk_mysql::libdev
  include mysql::client

  # This is required to create Jenkins SSH slaves, but it cannot be declared
  # in the defined type itself
  file { "${jenkins_homedir}/nodes":
    ensure  => directory,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0775',
    require => Class['govuk_jenkins::user'],
  }

  file { "${jenkins_homedir}/users":
    ensure  => directory,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0775',
    require => Class['govuk_jenkins::user'],
  }

}
