# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_frontend (
  #FIXME #73421574: remove when we are off old preview and it is no longer possible
  #       to access apps directly from the internet
  $app_basic_auth = false
) inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::collections':           vhost_protected => $app_basic_auth;
    'govuk::apps::contacts_frontend':     vhost_protected => $app_basic_auth;
    'govuk::apps::designprinciples':      vhost_protected => $app_basic_auth;
    'govuk::apps::feedback':              vhost_protected => $app_basic_auth;
    'govuk::apps::frontend':              vhost_protected => $app_basic_auth;
    'govuk::apps::info_frontend':         vhost_protected => $app_basic_auth;
    'govuk::apps::manuals_frontend':      vhost_protected => $app_basic_auth;
    'govuk::apps::service_manual':        vhost_protected => $app_basic_auth;
    'govuk::apps::specialist_frontend':   vhost_protected => $app_basic_auth;
  }

  class { 'govuk::apps::contacts':
    vhost_protected => $app_basic_auth,
    vhost           => 'contacts-frontend-old',
  }

  include govuk::apps::canary_frontend
  include govuk::apps::static
  include govuk::apps::transactions_explorer

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target    => "${::fqdn_underscore}.nginx.nginx_connections-writing",
    warning   => 150,
    critical  => 250,
    desc      => 'nginx high conn writing - upstream indicator',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#nginx-high-conn-writing-upstream-indicator-check',
  }
}
