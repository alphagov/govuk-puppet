# == Class: icinga::nginx
#
# Sets up nginx for Icinga
#
class icinga::nginx {
  include ::nginx

  nginx::config::ssl { 'nagios':
    certtype => 'wildcard_publishing',
  }

  nginx::config::site { 'nagios':
    content => template('icinga/nginx.conf.erb'),
  }

  nginx::log {
    'nagios-json.event.access.log':
      json      => true,
      logstream => present;
    'nagios-error.log':
      logstream => present;
  }
}
