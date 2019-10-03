# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define nginx::log (
  $logpath       = '/var/log/nginx',
  $logstream     = absent,
  $json          = false,
  $logname       = regsubst($name, '\.[^.]*$', ''),
  $statsd_metric = undef,
  $statsd_timers = [],
  ){

  # Log name should not be absolute. Use $logpath.
  validate_re($title, '^[^/]')

  $path = "${logpath}/${name}"
  $tags = ['nginx']
  $fields = {'application' => $logname}

  govuk_logging::logstream { $name:
    ensure        => $logstream,
    logfile       => $path,
    tags          => $tags,
    fields        => $fields,
    statsd_metric => $statsd_metric,
    statsd_timers => $statsd_timers,
  }

  if $json {
    $json_hash = {add_error_key => true}
  } else {
    $json_hash = {}
  }

  @filebeat::prospector { $name:
    ensure => $logstream,
    paths  => [$path],
    json   => $json_hash,
    tags   => $tags,
    fields => $fields,
  }
}
