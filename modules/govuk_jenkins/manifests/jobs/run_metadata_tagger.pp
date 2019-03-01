# == Class: govuk_jenkins::jobs::run_metadata_tagger
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::run_metadata_tagger {
  $job_name = 'Run_Rummager_Metadata_Tagger'
  $target_application = 'rummager'

  file { '/etc/jenkins_jobs/jobs/run_metadata_tagger.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_metadata_tagger.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
