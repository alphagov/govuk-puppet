# == Class: govuk_jenkins::job::dfid_transition_import
#
# Remove the file that was previously parsed by jenkins-job-builder
# TODO: delete this file when the job is gone from integration
#
class govuk_jenkins::job::dfid_transition_import () {
  file { '/etc/jenkins_jobs/jobs/dfid_transition_import.yaml':
    ensure => absent,
    notify => Exec['jenkins_jobs_update'];
  }
}
