# == Class: govuk_jenkins::jobs::mongo_data_sync
#
# Create a jenkins job to run the mongo data-sync manually
#
class govuk_jenkins::jobs::mongo_data_sync {
  file { '/etc/jenkins_jobs/jobs/mongo_data_sync.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/mongo_data_sync.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

