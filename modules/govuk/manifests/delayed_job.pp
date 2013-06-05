class govuk::delayed_job {
  file { '/usr/local/bin/govuk_run_delayed_job_worker':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_run_delayed_job_worker',
    mode    => '0755',
  }
}
