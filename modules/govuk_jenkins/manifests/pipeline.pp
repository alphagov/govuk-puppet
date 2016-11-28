# == Class: Govuk_jenkins::Pipeline
#
# Create dependencies for creating Jenkins pipelines
#
# === Parameters:
#
# [*user*]
#   The user which owns Jenkins directories
#
# [*group*]
#   The group which owns Jenkins directories
#
class govuk_jenkins::pipeline (
  $user  = 'jenkins',
  $group = 'jenkins',
) {
  file { '/var/lib/jenkins/groovy_scripts':
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => Class['govuk_jenkins::user'],
  }

  file { '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy':
    ensure  => file,
    owner   => $user,
    group   => $group,
    source  => 'puppet:///modules/govuk_jenkins/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy',
    require => File['/var/lib/jenkins/groovy_scripts'],
  }
}
