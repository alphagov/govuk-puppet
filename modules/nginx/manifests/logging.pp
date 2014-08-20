# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
    'access.log':
      logstream => absent;
    'error.log':
      logstream => present;
  }
}
