# == Define: govuk_ci::job
#
# Create a Jenkins multibranch Pipeline job for GOV.UK CI
#
# === Parameters
#
# [*app*]
# Application name (Default: title)
#
# [*repository*]
# Repository name, it needs to match the Github repository name (Default: title)
#
define govuk_ci::job (
  $app = $title,
  $repository = $title,
) {

  $job_config_directory = '/var/lib/jenkins/jobs'
  $application_directory = "${job_config_directory}/${app}"

  file { [ $job_config_directory, $application_directory ]:
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  file { "${application_directory}/config.xml":
    ensure  => present,
    content => template('govuk_ci/application_build_job.xml.erb'),
    require => File[$application_directory],
  }

}
