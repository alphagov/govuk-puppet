class nagios::nginx {
  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))
  $protect_monitoring = str2bool(extlookup('monitoring_protected','yes'))

  include ::nginx

  nginx::config::ssl { 'nagios':
    certtype => 'wildcard_alphagov',
  }

  nginx::config::site { 'nagios':
    content => template('nagios/nginx.conf.erb'),
  }

  nginx::log {
    'nagios-json.event.access.log':
      json      => true,
      logstream => true;
    'nagios-access.log':
      logstream => false;
    'nagios-error.log':
      logstream => true;
  }
}
