define govuk::procfile::worker (
  $setenv_as = $title
) {
  include govuk::procfile

  $service_name = "${title}-procfile-worker"
  $enable_service = $::govuk_platform ? {
    'development' => false,
    default       => true,
  }

  file { "/etc/init/${service_name}.conf":
    ensure    => present,
    content   => template('govuk/procfile-worker.conf.erb'),
    notify    => Service[$service_name],
    subscribe => Class['Govuk::Procfile'],
  }

  service { $service_name:
    ensure  => $enable_service,
  }
}
