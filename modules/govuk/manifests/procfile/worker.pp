define govuk::procfile::worker (
  $setenv_as = $title
) {
  include govuk::procfile

  $enable_service = $::govuk_platform ? {
    'development' => false,
    default       => true,
  }

  file { "/etc/init/${title}-procfile-worker.conf":
    ensure    => present,
    content   => template('govuk/procfile-worker.conf.erb'),
    notify    => Service["${title}-procfile-worker"],
    subscribe => Class['Govuk::Procfile'],
  }

  service { "${title}-procfile-worker":
    ensure  => $enable_service,
  }
}
