# == Class: govuk_jenkins::job::performance_platform_smokey
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*pp_full_app_domain*]
#   The domain used when the environment must be specified. e.g. production.performance.service.gov.uk 
#   (used for stagecraft)
#
# [*pp_app_domain*]
#   The domain used when no environment is specifiedi e.g. performance.service.gov.uk 
#   (used for backdrop)
#
# [*signon_username*]
#   Username for signon
#
# [*signon_password*]
#   Password for signon
#
class govuk_jenkins::job::performance_platform_smokey (
  $pp_full_app_domain = undef,
  $pp_app_domain = undef,
  $signon_username = undef,
  $signon_password = undef,
) {
  file { '/etc/jenkins_jobs/jobs/performance_platform_smokey.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/performance_platform_smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
