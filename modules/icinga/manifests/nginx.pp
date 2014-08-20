# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::nginx {
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
