# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_calculators_frontend inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include govuk_aws_xray_daemon

  include nginx

  # Local proxy for licence-finder to access ES cluster.
  if (! $::aws_migration) or ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    include govuk_elasticsearch::local_proxy
  }

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

  # Only for testing
  if $::aws_environment == 'staging' {
    include govuk_splunk
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    $app_domain = hiera('app_domain')

    govuk_envvar {
      'PLEK_SERVICE_SEARCH_URI': value    => "https://search.${app_domain}";
      'PLEK_SERVICE_RUMMAGER_URI': value  => "https://rummager.${app_domain}";
      'PLEK_SERVICE_EMAIL_ALERT_API_URI': value  => "https://email-alert-api.${app_domain}";
      'PLEK_SERVICE_PUBLISHING_API_URI': value  => "https://publishing-api.${app_domain}";
      'PLEK_SERVICE_WHITEHALL_ADMIN_URI': value  => "https://whitehall-admin.${app_domain}";
    }
  }
}
