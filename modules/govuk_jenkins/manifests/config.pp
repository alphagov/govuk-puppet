# Class: govuk_jenkins::config.pp
#
# This class templates the standard Jenkins configuration XML files.
# If configuration is not due to change often templating this config
# will help signficantly with deployment of new Jenkins machines,
# particularly in regarding to plugin configuration e.g. Github oauth.
#
# == Parameters:
#
# [*app_domain*]
#   The full domain for this environment. This is specifically used
#   within Location Configuration template.
#
# [*banner_colour_background*]
#   The background colour of the banner to display in the Jenkins web interface.
#
# [*banner_colour_text*]
#   The colour of the banner text to display in the Jenkins web interface.
#
# [*banner_string*]
#   The string to be displayed inside the banner in the Jenkins web interface.
#
# [*environment_variables*]
#   A hash of environment variables that should be set for all Jenkins jobs.
#
# [*github_web_uri*]
#   Set the Github Web URI as required by the Github Oauth Plugin.
#
# [*github_api_uri*]
#   Set the Github API URI as required by the Github Oauth Plugin.
#
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret*]
#   The Github client secret is used to authenticate against Github.
#
# [*theme_colour*]
#   The colour that is used to indicate the environment in Jenkins web interface.
#
# [*theme_text_colour*]
#   The colour of text that sits on theme_colour.
#
# [*theme_environiment_name*]
#   The environment name that is shown in Jenkins.
#
# [*admins*]
#   List of admins that have "admin" permissions in Jenkins.
#
# [*manage_config*]
#   Option to manage the Jenkins config or not. This is set so we do not
#   overwrite configuration in live environments.
#
class govuk_jenkins::config (
  $app_domain = hiera('app_domain'),
  $banner_colour_background = 'black',
  $banner_colour_text = 'white',
  $banner_string = 'Jenkins',
  $environment_variables = {},
  $theme_colour = '#222',
  $theme_text_colour = 'white',
  $theme_environment_name = 'Jenkins',
  $github_web_uri,
  $github_api_uri,
  $github_client_id,
  $github_client_secret,
  $admins = [],
  $manage_config = false,
) {

  validate_array($admins)

  if $manage_config {
    file { '/var/lib/jenkins':
      ensure  => directory,
      source  => 'puppet:///modules/govuk_jenkins/var/lib/jenkins',
      recurse => 'remote',
      owner   => 'jenkins',
      group   => 'jenkins',
      notify  => Service['jenkins'],
    }

    file { '/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml':
      ensure  => present,
      content => template('govuk_jenkins/config/jenkins.model.JenkinsLocationConfiguration.xml.erb'),
      owner   => 'jenkins',
      group   => 'jenkins',
      notify  => Service['jenkins'],
    }

    file { '/var/lib/jenkins/config.xml':
      ensure  => present,
      content => template('govuk_jenkins/config/config.xml.erb'),
      require => File['/var/lib/jenkins'],
      owner   => 'jenkins',
      group   => 'jenkins',
      notify  => Service['jenkins'],
    }

    file { '/var/lib/jenkins/userContent/header-crown.png':
      ensure => present,
      source => 'puppet:///modules/govuk_jenkins/userContent/header-crown.png',
      owner  => 'jenkins',
      group  => 'jenkins',
      notify => Service['jenkins'],
    }

    file { '/var/lib/jenkins/userContent/govuk.css':
      ensure  => present,
      content => template('govuk_jenkins/userContent/govuk.css.erb'),
      owner   => 'jenkins',
      group   => 'jenkins',
      notify  => Service['jenkins'],
    }
  }
}
