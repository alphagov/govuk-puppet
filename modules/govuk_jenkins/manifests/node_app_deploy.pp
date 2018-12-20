# == Define: Govuk_jenkins::Node_app_deploy
#
# Create job configuration that triggers downstream builds of all the apps
# on a specific node class.
#
# === Parameters:
#
# [*project_dir*]
#   The project directory where to store all the created jobs.
#
# [*user*]
#   User that Jenkins runs as.
#
# [*apps_to_deploy*]
#   An array of apps to deploy for a given node.
#
define govuk_jenkins::node_app_deploy (
  $project_dir,
  $user = 'jenkins',
  $apps = [],
  $environment = 'development',
  $auth_token = '',
) {

  validate_array($apps)

  # FIXME: These are apps which are only created by Puppet rather than
  # deployed through Jenkins. They should be moved elsewhere in the future
  # to avoid confusion.
  $blacklist = [
    'asset_env_sync',
    'event-store',
    'canary-backend',
    'canary-frontend',
    'publicapi',
    'draft-publicapi',
    'support_api_csv_env_sync',
  ]

  unless empty($apps) {
    File {
      owner => $user,
      group => $user,
    }

    file { "${project_dir}/jobs/${title}":
      ensure => 'directory',
    }

    # We need to do a hard restart when creating jobs on disk
    file { "${project_dir}/jobs/${title}/config.xml":
      ensure  => 'present',
      content => template('govuk_jenkins/node_app_deploy.xml.erb'),
      notify  => Service['jenkins'],
    }
  }
}
