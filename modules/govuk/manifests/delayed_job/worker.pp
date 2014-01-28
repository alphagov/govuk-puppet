define govuk::delayed_job::worker (
  $setenv_as = $title
) {
  include govuk::delayed_job

  $service_name = "${title}-delayed-job-worker"
  $enable_service = $::govuk_platform ? {
    'development' => false,
    default       => true,
  }

  file { "/etc/init/${service_name}.conf":
    ensure    => present,
    content   => template('govuk/delayed-job-worker.conf.erb'),
    notify    => Service[$service_name],
    subscribe => Class['Govuk::Delayed_job'],
  }

  service { $service_name:
    ensure  => $enable_service,
  }

  if $enable_service {
    @@icinga::check { "check_app_${title}_delayed_job_worker_upstart_up_${::hostname}":
      check_command       => "check_nrpe!check_upstart_status!${service_name}",
      service_description => "${title} delayed job worker upstart up",
      host_name           => $::fqdn,
    }
  }
}
