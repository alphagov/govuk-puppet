define nginx::config::vhost::licensify_upload($port='9000') {
  $app_domain = hiera('app_domain')
  $vhost_name = "uploadlicence.${app_domain}"
  $vhost_escaped = regsubst($vhost_name, '\.', '_', 'G')

  $counter_basename = "${::fqdn_underscore}.nginx_logs.${vhost_escaped}"

  nginx::config::ssl { $vhost_name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost_name: content => template('nginx/licensify-upload-vhost.conf') }
  nginx::log {
    "${vhost_name}-json.event.access.log":
      json          => true,
      logstream     => present,
      statsd_metric => "${counter_basename}.http_%{@fields.status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => '@fields.request_time'}];
    "${vhost_name}-access.log":
      logstream => absent;
    "${vhost_name}-error.log":
      logstream => present;
  }

  statsd::counter { "${counter_basename}.http_500": }

  @@icinga::check::graphite { "check_nginx_5xx_${vhost_name}_on_${::hostname}":
    target    => "transformNull(stats.${counter_basename}.http_5xx,0)",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => "${vhost_name} high nginx 5xx rate",
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=nagios#nginx-5xx-rate-too-high-for-many-apps-boxes',
  }
}
