# == Class: icinga::nginx
#
# Sets up nginx for Icinga
#
# === Parameters:
#
# [*enable_basic_auth*]
#   Boolean. Whether basic auth should be enabled or disabled.
#
class icinga::nginx (
  $enable_basic_auth = true,
) {
  validate_bool($enable_basic_auth)

  include ::nginx

  nginx::config::ssl { 'nagios':
    certtype => 'wildcard_alphagov_mgmt',
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
