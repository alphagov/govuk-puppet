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

  # FIXME: remove when deployed
  file { '/var/lib/jenkins/groovy_scripts':
    ensure  => absent,
  }

  # FIXME: remove when deployed
  file { '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy':
    ensure  => absent,
  }

  $jenkins_libraries = {
    'govuk' => {
      'org'             => 'alphagov',
      'repository'      => 'govuk-jenkinslib',
      'implicit_load'   => false,
      'default_version' => 'master',
    },
  }

  file { '/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml':
    ensure  => present,
    owner   => $user,
    group   => $group,
    content => template('govuk_jenkins/config/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml'),
  }
}
