class mapit::nginx {
  include ::nginx

  nginx::config::ssl { 'wildcard_alphagov':
    certtype => 'wildcard_alphagov'
  }

  nginx::config::site { 'mapit':
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }

  nginx::log {
    'mapit.json.event.access.log':
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.mapit.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.mapit.time_request",
                          value => '@fields.request_time'}];
    'mapit.access.log':
      logstream => false;
    'mapit.error.log':
      logstream => true;
  }
}
