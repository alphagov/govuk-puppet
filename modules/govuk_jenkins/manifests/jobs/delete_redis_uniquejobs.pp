# == Class: govuk_jenkins::jobs::delete_redis_uniquejobs
#
# Create a jenkins job to periodically remove redis uniquejobs key
#
class govuk_jenkins::jobs::delete_redis_uniquejobs {
  file { '/etc/jenkins_jobs/jobs/delete_redis_uniquejobs.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/delete_redis_uniquejobs.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

