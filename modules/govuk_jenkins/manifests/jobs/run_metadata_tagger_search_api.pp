# == Class: govuk_jenkins::jobs::run_metadata_tagger_search_api
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::run_metadata_tagger_search_api {
  $job_name = 'Run_Search_API_Metadata_Tagger'
  $target_application = 'search-api'

  file { '/etc/jenkins_jobs/jobs/run_metadata_tagger_search_api.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_metadata_tagger.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
