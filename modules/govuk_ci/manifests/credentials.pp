# == Class: govuk_ci::credentials
#
# Create a set of credentials that the CI machines require.
#
# === Parameters:
#
# [*npm_auth*]
#   Auth code for npm
#
# [*npm_email*]
#   Email for npn
#
# [*rubygems_api_key*]
#   API key to authenticate with Rubygems
#
# [*gemfury_api_key*]
#   API key to authenticate with Gemfury
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
  $npm_auth,
  $npm_email,
  $rubygems_api_key,
  $gemfury_api_key,
  $pypi_username,
  $pypi_test_password,
  $pypi_live_password,
  $jenkins_home = '/var/lib/jenkins',
  $jenkins_user = 'jenkins',
) {

  file {'jenkins_dotgem_dir':
    ensure => directory,
    path   => "${jenkins_home}/.gem",
    owner  => $jenkins_user,
    group  => $jenkins_user,
    mode   => '0700',
  }

  file {"${jenkins_home}/.gem/credentials":
    ensure  => present,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0600',
    content => template('govuk_ci/dotgem/credentials.erb'),
    require => File['jenkins_dotgem_dir'],
  }

  file {"${jenkins_home}/.pypirc":
    ensure  => present,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0600',
    content => template('govuk_ci/pypirc.erb'),
  }

  file {"${jenkins_home}/.gem/gemfury":
    ensure  => present,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0600',
    content => template('govuk_ci/dotgem/gemfury.erb'),
    require => File['jenkins_dotgem_dir'],
  }

  file { "${jenkins_home}/.npmrc":
    ensure  => present,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0600',
    content => template('govuk_ci/npmrc.erb'),
  }
}

