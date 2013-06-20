define nginx::log (
  $logpath       = '/var/log/nginx',
  $logowner      = 'www-data',
  $loggroup      = 'adm',
  $logmode       = '0640',
  $logstream     = false,
  $json          = false,
  $logname       = regsubst($name, '\.[^.]*$', ''),
  $statsd_metric = undef
  ){

  # Log name should not be absolute. Use $logpath.
  validate_re($title, '^[^/]')

  file { "${logpath}/${name}":
    ensure  => 'present',
    owner   => $logowner,
    group   => $loggroup,
    mode    => $logmode,
    content => '',
    replace => false,
    require => Class['nginx::package'],
  }

  govuk::logstream { $name:
    logfile       => "${logpath}/${name}",
    tags          => ['nginx'],
    fields        => {'application' => $logname},
    enable        => $logstream,
    json          => $json,
    statsd_metric => $statsd_metric,
  }

}
