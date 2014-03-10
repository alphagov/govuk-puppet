define nginx::log (
  $logpath       = '/var/log/nginx',
  $logowner      = 'www-data',
  $loggroup      = 'adm',
  $logmode       = '0640',
  $logstream     = absent,
  $json          = false,
  $logname       = regsubst($name, '\.[^.]*$', ''),
  $statsd_metric = undef,
  $statsd_timers = [],
  $ensure        = 'present',
  ){

  # Log name should not be absolute. Use $logpath.
  validate_re($title, '^[^/]')

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  file { "${logpath}/${name}":
    ensure  => $ensure,
    owner   => $logowner,
    group   => $loggroup,
    mode    => $logmode,
    content => '',
    replace => false,
    require => Class['nginx::package'],
  }

  $logstream_ensure = $ensure ? {
    'present' => $logstream,
    'absent'  => 'absent',
  }

  govuk::logstream { $name:
    ensure        => $logstream_ensure,
    logfile       => "${logpath}/${name}",
    tags          => ['nginx'],
    fields        => {'application' => $logname},
    json          => $json,
    statsd_metric => $statsd_metric,
    statsd_timers => $statsd_timers
  }

}
