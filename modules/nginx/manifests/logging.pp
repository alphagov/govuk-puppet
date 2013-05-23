class nginx::logging {
  file { '/etc/logrotate.d/nginx':
    ensure => present,
    source => 'puppet:///modules/nginx/etc/logrotate.d/nginx',
  }

  nginx::log {
    'json.event.access.log':
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.default.http_%{@fields.status}";
    'access.log':
      logstream => false;
    'error.log':
      logstream => true;
  }
}
