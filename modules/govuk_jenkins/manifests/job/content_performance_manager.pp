# == Class: govuk_jenkins::job::content_performance_manager
#
# Create a jenkins job to periodically run rake for the following tasks:
# - import:all_content_items
#
# === Parameters:
#
# [*rake_import_all_content_items_frequency *]
#   The cron timings for the import:all_content_items rake task
#   Default: undef
#
class govuk_jenkins::job::content_performance_manager (
  $rake_import_all_content_items_frequency = undef,
) {
  file { '/etc/jenkins_jobs/jobs/content_performance_manager.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_performance_manager.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
