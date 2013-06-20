# = Class: router::assets_origin
#
# Configure vhost for serving external-facing assets (also known as static).
#
class router::assets_origin {
  $app_domain = extlookup('app_domain')

  # suspect we want `protected => false` here
  # once appropriate firewalling is in place?
  nginx::config::site { 'assets-origin.digital.cabinet-office.gov.uk':
    content => template('router/assets_origin.conf.erb'),
  }

  nginx::config::ssl { 'assets-origin.digital.cabinet-office.gov.uk':
    certtype => 'wildcard_alphagov'
  }

  nginx::log {
    'assets-origin.digital.cabinet-office.gov.uk-json.event.access.log':
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.assets-origin.http_%{@fields.status}";
    'assets-origin.digital.cabinet-office.gov.uk-error.log':
      logstream => true;
  }
}
