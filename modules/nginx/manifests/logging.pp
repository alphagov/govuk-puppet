class nginx::logging {
  file { '/etc/logrotate.d/nginx':
    ensure => present,
    source => 'puppet:///modules/nginx/etc/logrotate.d/nginx',
  }

  nginx::log {
    'json.event.access.log':
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.default.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.default.time_request", value => "@fields.request_time"}];
    'access.log':
      logstream => false;
    'error.log':
      logstream => true;
  }
}
