# == Class: govuk::node::s_email_campaign_frontend
#
# Frontend machines for email campaigns.
#
class govuk::node::s_email_campaign_frontend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

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
}
