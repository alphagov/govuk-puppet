# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_frontend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  include govuk::apps::collections
  include govuk::apps::contacts_frontend
  include govuk::apps::courts_frontend
  include govuk::apps::designprinciples
  include govuk::apps::feedback
  include govuk::apps::frontend
  include govuk::apps::government_frontend
  include govuk::apps::info_frontend
  include govuk::apps::manuals_frontend
  include govuk::apps::service_manual
  include govuk::apps::specialist_frontend

  class { 'govuk::apps::contacts':
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
