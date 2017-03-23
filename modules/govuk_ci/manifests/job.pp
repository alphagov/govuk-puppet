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
# Github repository owner. If source is set to 'github-enterprise' repo_owner will always be set to 'gds'.
# Default: alphagov
#
# [*source*]
# Type of Branch Source plugin to use in the Jenkins job. It can be 'github' or 'github-enterprise' (for Github Enterprise projects)
# Default: github
#
# [*branches_to_exclude*]
# Array of branches which should _not_ be built by the CI server, for example because they are labels for releases
# rather than development work. '*' may be used as a wildcard.
# Default: release, deployed-to-integration, deployed-to-staging, integration, staging, production
#
define govuk_ci::job (
  $app = $title,
  $repository = $title,
  $repo_owner = 'alphagov',
  $source = 'github',
  $branches_to_exclude = [
    'release',
    'deployed-to-integration',
    'deployed-to-staging',
    'integration',
    'staging',
    'production',
  ],
) {

  validate_re($source, '^(github|github-enterprise)$', 'Invalid source value, it must be github or github-enterprise')

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
    notify  => Class['Govuk_jenkins::Reload'],
  }

}
