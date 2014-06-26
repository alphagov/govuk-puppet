class icinga::nginx {
  $enable_ssl = hiera('nginx_enable_ssl', true)
  $protect_monitoring = str2bool(hiera('monitoring_protected','yes'))

  include ::nginx

  nginx::config::ssl { 'nagios':
    certtype => 'wildcard_alphagov',
  }

  nginx::config::site { 'nagios':
    content => template('icinga/nginx.conf.erb'),
  }

  nginx::log {
    'nagios-json.event.access.log':
      json      => true,
      logstream => present;
    'nagios-access.log':
      logstream => absent;
    'nagios-error.log':
      logstream => present;
  }
}
