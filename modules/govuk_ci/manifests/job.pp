# == Define: govuk_ci::job
#
# Create a Jenkins multibranch Pipeline job for GOV.UK CI
#
# === Parameters
#
# [*app*]
# Application name
# Default: title
#
# [*repository*]
# Repository name. It needs to match the Github/Github Enterprise repository name
# Default: title
#
# [*repo_owner*]
# Github repository owner
# Default: alphagov
#
# [*source*]
# Type of Branch Source plugin to use in the Jenkins job. It can be 'github' or 'git' (for Github Enterprise projects)
# Default: github
#
define govuk_ci::job (
  $app = $title,
  $repository = $title,
  $repo_owner = 'alphagov',
  $source = 'github',
) {

  validate_re($source, '^(github|git)$', 'Invalid source value, it must be github or git')

  $job_config_directory = '/var/lib/jenkins/jobs'
  $application_directory = "${job_config_directory}/${app}"

  file { $application_directory :
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  file { "${application_directory}/config.xml":
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    content => template('govuk_ci/application_build_job.xml.erb'),
    require => File[$application_directory],
  }

}
