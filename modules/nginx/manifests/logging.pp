# == Class: nginx::logging
#
# Nginx log centralisation and rotation.
#
class nginx::logging {
  @logrotate::conf { 'nginx':
    matches         => '/var/log/nginx/*.log',
    days_to_keep    => '28',
    copytruncate    => false,
    create          => '0640 www-data adm',
    delaycompress   => true,
    prerotate       => 'if [ -d /etc/logrotate.d/httpd-prerotate ]; then run-parts /etc/logrotate.d/httpd-prerotate; fi',
    postrotate      => '[ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`',
    rotate_if_empty => true,
    sharedscripts   => true,
  }

  nginx::log {
    'json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_metrics}.nginx_logs.default.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_metrics}.nginx_logs.default.time_request",
                          value => '@fields.request_time'}];
    'error.log':
      logstream => present;
  }
}
