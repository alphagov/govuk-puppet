# == Class: Govuk_jenkins::Cli
#
# Adds the pre-reqs and command for easily running the
# jenkins-cli.
#
# Currently only supported on Jenkins 2 as the required credentials
# using an SSH key is not possible on Jenkins 1.
#
# This should have a user enabled that has the appropriate public SSH
# key assigned to it. Add this manually via the UI in advance
# otherwise the tool will fail.
#
# === Parameters:
#
# [*jenkins_url*]
#   The URL of the Jenkins instance. Must include protocol and ports:
#   http://localhost:8080
#
# [*jar_directory*]
#   Where to install the Jenkins CLI jar file.
#
# [*jenkins_api_user*]
#   The user used to authenticate with the Jenkins API.

# [*jenkins_api_token*]
#   The token used to authenticate with the Jenkins API.
#
class govuk_jenkins::cli (
  $jenkins_url = 'http://localhost:8080',
  $jar_directory = '/var/lib/jenkins',
  $jenkins_api_user = 'jenkins_api_user',
  $jenkins_api_token = '',
) {
  curl::fetch { 'Jenkins CLI tool':
    source      => "${jenkins_url}/jnlpJars/jenkins-cli.jar",
    destination => "${jar_directory}/jenkins-cli.jar",
    timeout     => 0,
    verbose     => false,
  }

  file { '/usr/local/bin/jenkins-cli':
    mode    => '0755',
    content => template('govuk_jenkins/jenkins-cli.erb'),
    require => Curl::Fetch['Jenkins CLI tool'],
  }
}
