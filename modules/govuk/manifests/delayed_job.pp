# Temporary code to remove delayed job related files & services
class govuk::delayed_job {
  file { '/usr/local/bin/govuk_run_delayed_job_worker':
    ensure => absent,
  }
}
