# == Class: govuk_jenkins::jobs::copy_sanitised_whitehall_database
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::copy_sanitised_whitehall_database (
  $whitehall_mysql_password = undef,
  $mysql_dst_root_pw = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'copy_sanitised_whitehall_database'
  $service_description = 'Copy Sanitised Whitehall Database'
  $job_url = "https://deploy.${app_domain}/job/copy_sanitised_whitehall_database"

  file { '/etc/jenkins_jobs/jobs/copy_sanitised_whitehall_database.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_sanitised_whitehall_database.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 115200,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(data-sync),
  }
}
