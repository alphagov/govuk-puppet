# == Class: govuk_jenkins::jobs::content_performance_manager
#
# Create a jenkins job to periodically run rake for the following tasks:
# - import:all_content_items
#
# === Parameters:
#
class govuk_jenkins::jobs::content_performance_manager (
) {
  file { '/etc/jenkins_jobs/jobs/content_performance_manager.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_performance_manager.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
