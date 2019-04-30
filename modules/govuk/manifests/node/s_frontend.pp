# == Class: govuk::node::s_frontend
#
# Frontend machine definition. Frontend machines run applications
# which serve web pages to users.
#
class govuk::node::s_frontend inherits govuk::node::s_base {

  include govuk::node::s_app_server

  include govuk_aws_xray_daemon

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target    => "${::fqdn_metrics}.nginx.nginx_connections-writing",
    warning   => 150,
    critical  => 250,
    desc      => 'nginx high conn writing - upstream indicator',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-high-conn-writing-upstream-indicator-check),
  }

  include ::collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '0.0.0.0',
  }

  govuk_envvar {
    'UNICORN_TIMEOUT': value => 15;
  }

  if ( ( $::aws_migration == 'frontend' ) and ($::aws_environment == 'staging') ) or ( ($::aws_migration == 'frontend' ) and ($::aws_environment == 'production') ) {
    $app_domain = hiera('app_domain')

    govuk_envvar {
      'PLEK_SERVICE_EMAIL_ALERT_API_URI': value  => "https://email-alert-api.${app_domain}";
      'PLEK_SERVICE_PUBLISHING_API_URI': value  => "https://publishing-api.${app_domain}";
    }
  }
}
