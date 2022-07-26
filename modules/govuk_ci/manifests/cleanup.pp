# == Class: govuk_ci::cleanup
#
#  General cleanup of filesystem.
#
# === Parameters:
#
# [*jenkins_workspace_max_age*]
#   Maximum age -in days- of Jenkins workspaces before they are deleted by the cleanup job.
#
class govuk_ci::cleanup (
  $jenkins_workspace_max_age = 90,
){
  cron::crondotdee { 'clean_up_workspace':
    command => "find /var/lib/jenkins/workspace/ -maxdepth 1 -mindepth 1 -type d -mtime +${jenkins_workspace_max_age} -exec rm -rf {} \\;",
    hour    => 7,
    minute  => 25,
  }
}
