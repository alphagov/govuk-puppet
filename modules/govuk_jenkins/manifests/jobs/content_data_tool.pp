# == Class: govuk_jenkins::jobs::content_audit_tool
#
# Create a jenkins job to periodically run rake for the following tasks:
# - import:all_content_items
# - import:all_ga_metrics
#
# === Parameters:
#
# [*rake_import_all_content_items_frequency *]
#   The cron timings for the import:all_content_items rake task
#   Default: undef
#
# [*rake_import_all_ga_metrics_frequency *]
#   The cron timings for the import:all_ga_metrics rake task
#   Default: undef
#
class govuk_jenkins::jobs::content_audit_tool (
  $rake_import_all_content_items_frequency = undef,
  $rake_import_all_ga_metrics_frequency = undef,
) {
  file { '/etc/jenkins_jobs/jobs/content_audit_tool.yaml':
    ensure  => absent,
    content => template('govuk_jenkins/jobs/content_audit_tool.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
