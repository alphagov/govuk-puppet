# == Class: govuk_jenkins::jobs::smokey
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*environment*]
#   The environment which is running Smokey. Used to build the rake task.
#
# [*smokey_cron_schedule*]
#   The cron timings for the Smokey job.
#   This replaces the old 'Smokey Loop', so should run as close to
#   'continuously' as possible (without risking building up queues in the
#   system).
#   Default: '*/10 7-19 * * 1-5'
#
# [*smokey_timeout*]
#   Time limit (in seconds) in which the Smokey job must be completed
#   before being automatically aborted.
#   Default: '300'
#
class govuk_jenkins::jobs::smokey (
  $environment = 'production',
  $smokey_cron_schedule = '*/10 7-19 * * 1-5',
  $smokey_timeout = '300',
) {
  include govuk::apps::smokey

  file { '/etc/jenkins_jobs/jobs/smokey.yaml':
    ensure  => absent,
    content => template('govuk_jenkins/jobs/smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
    require => Class['govuk::apps::smokey'],
  }
}
