# == Class: govuk_jenkins::job::signon_cron_rake_tasks
#
# Create a jenkins job to periodically run rake for the following tasks:
# - oauth_access_grants:delete_expired
# - organisations:fetch
# - users:suspend_inactive
# - users:send_suspension_reminders
#
# === Parameters:
#
# [*configure_jobs*]
#   Whether we should configure these jenkins jobs
#   Default: false
#
# [*rake_oauth_access_grants_delete_expired_frequency*]
#   The cron timings for the oauth_access_grants:delete_expired rake task
#   Default: undef
#
# [*rake_organisations_fetch_frequency*]
#   The cron timings for the organisations:fetch rake task
#   Default: undef
#
# [*rake_users_suspend_inactive_frequency*]
#   The cron timings for the users:suspend_inactive rake task
#   Default: undef
#
# [*rake_users_send_suspension_reminders_frequency*]
#   The cron timings for the users:send_suspension_reminders rake task
#   Default: undef
#
class govuk_jenkins::job::signon_cron_rake_tasks (
  $configure_jobs = false,
  $rake_oauth_access_grants_delete_expired_frequency = undef,
  $rake_organisations_fetch_frequency = undef,
  $rake_users_suspend_inactive_frequency = undef,
  $rake_users_send_suspension_reminders_frequency = undef,
) {
  if $configure_jobs {
    file { '/etc/jenkins_jobs/jobs/signon_cron_rake_tasks.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/signon_cron_rake_tasks.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'],
    }
  }
}
