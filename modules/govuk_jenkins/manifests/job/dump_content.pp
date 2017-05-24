# == Class: govuk_jenkins::job::dump_content
#
# Create a jenkins job to dump the content from the content-store
#
#
# === Parameters:
#
class govuk_jenkins::job::dump_content {
  file { '/etc/jenkins_jobs/jobs/dump_content.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/dump_content.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
