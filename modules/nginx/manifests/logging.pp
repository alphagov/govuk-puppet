# == Class: nginx::logging
#
# Nginx log centralisation and rotation.
#
class nginx::logging {
  file { '/etc/logrotate.d/nginx':
    ensure => present,
    source => 'puppet:///modules/nginx/etc/logrotate.d/nginx',
  }

  nginx::log {
    'json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.default.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.default.time_request",
                          value => '@fields.request_time'}];
    'error.log':
      logstream => present;
  }
}
