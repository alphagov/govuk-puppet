# == Class: govuk_jenkins::job::dump_routes
#
# Create a jenkins job to dump the routes from the router-api
#
#
# === Parameters:
#
class govuk_jenkins::job::dump_routes {
  file { '/etc/jenkins_jobs/jobs/dump_routes.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/dump_routes.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
