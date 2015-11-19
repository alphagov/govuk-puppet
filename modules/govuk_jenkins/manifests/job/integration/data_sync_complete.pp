# == Class: govuk_jenkins::job::integration::data_sync_complete
#
# Create a Jenkins job that is triggered when the data sync from production finishes.
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
# [*signon_domain_old*]
#   Optional param which will run signon's rake task for
#   applications:migrate_domain if both this and `$signon_domain_new` are set.
#
# [*signon_domain_new*]
#   See docs for `$signon_domain_old`.
#
# [*pp_signon_domain_old*]
#   Optional param which will run signon's rake task for Performance Platform
#   applications:migrate_domain if both this and `$pp_signon_domain_new` are set.
#
# [*pp_signon_domain_new*]
#   See docs for `$pp_signon_domain_old`.
#
class govuk_jenkins::job::integration::data_sync_complete (
  $auth_token = undef,
  $signon_domain_old = undef,
  $signon_domain_new = undef,
  $pp_signon_domain_old = undef,
  $pp_signon_domain_new = undef,
) {
  file { '/etc/jenkins_jobs/jobs/data_sync_complete.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration/data_sync_complete.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
