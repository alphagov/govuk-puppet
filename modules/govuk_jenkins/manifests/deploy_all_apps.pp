# == Class: govuk_jenkins::deploy_all_apps
#
# Creates a project folder that contains all the jobs that deploy all apps on
# specific nodes.
#
# === Parameters:
#
# [*jobs_directory*]
#   This is where Jenkins jobs are set up.
#
# [*project_name*]
#   The name of the folder that the jobs will be inside.
#
# [*user*]
#   Which user Jenkins runs as.
#
# [*apps_on_nodes*]
#   A hash containing the node classes, and which apps run on them.
#
# [*deploy_environment*]
#   The environment to deploy to. This is important as we use it to find out
#   what version of the application should be deployed.
#
class govuk_jenkins::deploy_all_apps (
  $jobs_directory = '/var/lib/jenkins/jobs',
  $project_name = 'Deploy_Node_Apps',
  $user = 'jenkins',
  $apps_on_nodes = {},
  $deploy_environment = 'development',
  $auth_token = '',
) {

  $environment_variables = $govuk_jenkins::environment_variables
  $project_directory = "${jobs_directory}/${project_name}"

  File {
    owner => $user,
    group => $user,
  }

  file { $project_directory:
    ensure  => 'directory',
    require => Class['::govuk_jenkins'],
  }

  file { "${project_directory}/config.xml":
    ensure  => 'present',
    content => template('govuk_jenkins/folder_config.xml.erb'),
  }

  file { "${project_directory}/jobs":
    ensure  => 'directory',
    require => File["${jobs_directory}/${project_name}"],
    purge   => true,
  }

  $defaults = {
    project_dir => $project_directory,
    environment => $deploy_environment,
    auth_token  => $auth_token,
  }

  create_resources('govuk_jenkins::node_app_deploy', $apps_on_nodes, $defaults)
}
