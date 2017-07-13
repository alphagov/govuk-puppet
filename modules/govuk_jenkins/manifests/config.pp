# Class: govuk_jenkins::config
#
# This class templates the standard Jenkins configuration XML files.
# If configuration is not due to change often templating this config
# will help signficantly with deployment of new Jenkins machines,
# particularly in regarding to plugin configuration e.g. Github oauth.
#
# == Parameters:
#
# [*url_prefix*]
#   The prefix used on the URL to access the Jenkins instance. Default is 'deploy',
#   which would create "https://deploy.${app_domain}"
#
# [*app_domain*]
#   The domain name applied to the Jenkins instance URL
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
# [*views*]
#   Create a "list view" which contains specified jobs.
#
# [*admins*]
#   List of admins that have "admin" permissions in Jenkins.
#   Deprecated: use $manage_permissions_github_teams instead.
#
# [*user_permissions*]
#   Array of hashes that contain user (string "username", or "github_org*github_team")
#   and permissions (array of permissions).
#
# [*manage_permissions_github_teams*]
#   Boolean, whether or not to manage permissions using GitHub teams
#   instead of a list of users.
#
# [*manage_config*]
#   Boolean option to manage the Jenkins configuration directory.
#
# [*version*]
#   Specify the version of Jenkins
#
# [*create_agent_role*]
#   If enabled, this creates a role and assigns an "agent" user to that role
#   so that it may connect to the master
#
# [*executors*]
#   The number of executors a master can allocate to running jobs
#
# [*agent_tcp_port*]
#   When set to anything other than 0, it specifies the TCP port that the
#   Jenkins master connects to the Jenkins agent with (when using the JNLP
#   agent). Default is '0', which enables setting a random port number.
#
class govuk_jenkins::config (
  $url_prefix = 'deploy',
  $app_domain = hiera('app_domain'),
  $banner_colour_background = 'black',
  $banner_colour_text = 'white',
  $banner_string = 'Jenkins',
  $environment_variables = {},
  $theme_colour = '#222',
  $theme_text_colour = 'white',
  $theme_environment_name = 'Jenkins',
  $views = {},
  $github_web_uri,
  $github_api_uri,
  $github_client_id,
  $github_client_secret,
  $admins = [],
  $user_permissions = [],
  $manage_permissions_github_teams = false,
  $manage_config = true,
  $version = $govuk_jenkins::version,
  $create_agent_role = false,
  $executors = '4',
  $agent_tcp_port = '0',
) {

  $url = "${url_prefix}.${app_domain}"

  validate_array($admins)
  validate_array($user_permissions)
  validate_hash($views)

  if $manage_config {

    File {
      owner  => 'jenkins',
      group  => 'jenkins',
    }

    File {
      notify => Class['Govuk_jenkins::Reload'],
    }

    file {'/var/lib/jenkins/com.cloudbees.jenkins.GitHubPushTrigger.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/com.cloudbees.jenkins.GitHubPushTrigger.xml',
    }

    file {'/var/lib/jenkins/com.sonyericsson.rebuild.RebuildDescriptor.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/com.sonyericsson.rebuild.RebuildDescriptor.xml',
    }

    file {'/var/lib/jenkins/envInject.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/envInject.xml',
    }

    file {'/var/lib/jenkins/hudson.model.UpdateCenter.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/hudson.model.UpdateCenter.xml',
    }

    file {'/var/lib/jenkins/hudson.plugins.ansicolor.AnsiColorBuildWrapper.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/hudson.plugins.ansicolor.AnsiColorBuildWrapper.xml',
    }

    file {'/var/lib/jenkins/hudson.plugins.git.GitTool.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/hudson.plugins.git.GitTool.xml',
    }

    file {'/var/lib/jenkins/hudson.plugins.sitemonitor.SiteMonitorRecorder.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/hudson.plugins.sitemonitor.SiteMonitorRecorder.xml',
    }

    file {'/var/lib/jenkins/hudson.tasks.Shell.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/hudson.tasks.Shell.xml',
    }

    file {'/var/lib/jenkins/jenkins.model.ArtifactManagerConfiguration.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/jenkins.model.ArtifactManagerConfiguration.xml',
    }

    file {'/var/lib/jenkins/jenkins.model.DownloadSettings.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/jenkins.model.DownloadSettings.xml',
    }

    file {'/var/lib/jenkins/jenkins.mvn.GlobalMavenConfig.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/jenkins.mvn.GlobalMavenConfig.xml',
    }

    file {'/var/lib/jenkins/jenkins.security.QueueItemAuthenticatorConfiguration.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/jenkins.security.QueueItemAuthenticatorConfiguration.xml',
    }

    file {'/var/lib/jenkins/org.jenkinsci.plugins.conditionalbuildstep.singlestep.SingleConditionalBuilder.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/org.jenkinsci.plugins.conditionalbuildstep.singlestep.SingleConditionalBuilder.xml',
    }

    file {'/var/lib/jenkins/org.jenkinsci.plugins.gitclient.JGitTool.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/org.jenkinsci.plugins.gitclient.JGitTool.xml',
    }

    file {'/var/lib/jenkins/org.jvnet.hudson.plugins.SSHBuildWrapper.xml':
      ensure => file,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/org.jvnet.hudson.plugins.SSHBuildWrapper.xml',
    }

    file { '/var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml':
      ensure => present,
      source => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml',
    }

    file { '/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml':
      ensure  => present,
      content => template('govuk_jenkins/config/jenkins.model.JenkinsLocationConfiguration.xml.erb'),
    }

    file { '/var/lib/jenkins/config.xml':
      ensure  => present,
      content => template('govuk_jenkins/config/config.xml.erb'),
      require => File['/var/lib/jenkins'],
    }

    file { '/var/lib/jenkins/userContent/header-crown.png':
      ensure => present,
      source => 'puppet:///modules/govuk_jenkins/userContent/header-crown.png',
    }

    file { '/var/lib/jenkins/userContent/govuk.css':
      ensure  => present,
      content => template('govuk_jenkins/userContent/govuk.css.erb'),
    }
  }
}
