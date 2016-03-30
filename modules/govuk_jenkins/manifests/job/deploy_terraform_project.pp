# == Class: govuk_jenkins::job::deploy_terraform_project
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
# [*projects*]
#   An array that contains the list of projects currently configured to deploy
#
class govuk_jenkins::job::deploy_terraform_project (
  $apt_mirror_hostname = '',
  $projects = [],
) {
  validate_array($projects)

  file { '/etc/jenkins_jobs/jobs/deploy_terraform_project.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_terraform_project.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  apt::source { 'terraform':
    location     => "http://${apt_mirror_hostname}/terraform",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'terraform':
    ensure  => '0.6.14',
    require => Apt::Source['terraform'],
  }

}
