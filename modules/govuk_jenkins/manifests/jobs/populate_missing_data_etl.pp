class govuk_jenkins::jobs:: (
  $rerun_rake_etl_master_process_cron_schedule = undef,
) {
  file { '/etc/jenkins_jobs/jobs/populate_missing_data_etl.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/populate_missing_data_etl.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
