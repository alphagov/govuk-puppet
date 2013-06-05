class govuk::delayed_job {
  file { '/usr/local/bin/govuk_run_delayed_job_worker':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_run_delayed_job_worker',
    mode    => '0755',
  }
}

define govuk::delayed_job::worker (
  $setenv_as = $title
) {

  include govuk::delayed_job

  $enable_service = ($::govuk_platform != 'development')

  file { "/etc/init/${title}-delayed-job-worker.conf":
    ensure    => present,
    content   => template('govuk/delayed-job-worker.conf.erb'),
    notify    => Service["${title}-delayed-job-worker"],
    subscribe => Class['Govuk::Delayed_job'],
  }

  service { "${title}-delayed-job-worker":
    ensure  => $enable_service,
  }
}
