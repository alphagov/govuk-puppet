# Temporary code to remove delayed job related files & services
define govuk::delayed_job::worker (
  $setenv_as = $title,
  $enable_service = false,
) {
  include govuk::delayed_job

  $service_name = "${title}-delayed-job-worker"

  file { "/etc/init/${service_name}.conf":
    ensure  => absent,
  }

  service { $service_name:
    ensure    => $enable_service,
    notify    => File["/etc/init/${service_name}.conf"],
    subscribe => Class['Govuk::Delayed_job'],
  }
}
