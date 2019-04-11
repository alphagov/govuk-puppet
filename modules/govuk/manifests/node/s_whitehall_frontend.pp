# == Class: govuk::node::s_whitehall_frontend
#
# Configures a frontend server for the Whitehall application
#
class govuk::node::s_whitehall_frontend inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include govuk_aws_xray_daemon

  include nginx

  $app_domain = hiera('app_domain')

  nginx::config::vhost::redirect { "whitehall.${app_domain}":
    to => "https://whitehall-frontend.${app_domain}/",
  }

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '0.0.0.0',
  }

  govuk_envvar {
    'UNICORN_TIMEOUT': value => 15;
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {

    govuk_envvar {
      'PLEK_SERVICE_SEARCH_URI': value    => "https://search.${app_domain}";
      'PLEK_SERVICE_RUMMAGER_URI': value  => "https://rummager.${app_domain}";
      'PLEK_SERVICE_EMAIL_ALERT_API_URI': value  => "https://email-alert-api.${app_domain}";
      'PLEK_SERVICE_PUBLISHING_API_URI': value  => "https://publishing-api.${app_domain}";
    }
  }
}
