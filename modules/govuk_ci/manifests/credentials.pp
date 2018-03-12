# == Class: govuk_ci::credentials
#
# Create a set of credentials that the CI machines require.
#
# === Parameters:
#
# [*rubygems_api_key*]
#   API key to authenticate with Rubygems
#
# [*pypi_username*]
#  PyPi username
#
# [*pypi_test_password*]
#   PyPi password for testing
#
# [*pypi_live_password*]
#   PyPi password for live
#
# [*jenkins_home*]
#   Home directory that the credentials should be created in
#
# [*jenkins_user*]
#   The user that has access to these credentials
#
class govuk_ci::credentials (
  $rubygems_api_key,
  $pypi_username,
  $pypi_test_password,
  $pypi_live_password,
  $jenkins_home = '/var/lib/jenkins',
  $jenkins_user = 'jenkins',
) {

  File {
    ensure  => present,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0600',
    require => Class['::govuk_jenkins::user'],
  }

  file {'jenkins_dotgem_dir':
    ensure => directory,
    path   => "${jenkins_home}/.gem",
    mode   => '0700',
  }

  file {"${jenkins_home}/.gem/credentials":
    content => template('govuk_ci/dotgem/credentials.erb'),
    require => File['jenkins_dotgem_dir'],
  }

  file {"${jenkins_home}/.pypirc":
    content => template('govuk_ci/pypirc.erb'),
  }
}
