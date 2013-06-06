define govuk::delayed_job::worker (
  $setenv_as = $title
) {
  include govuk::delayed_job

  $enable_service = $::govuk_platform ? {
    'development' => false,
    default       => true,
  }

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
