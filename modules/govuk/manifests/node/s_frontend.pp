# == Class: govuk::node::s_frontend
#
# Frontend machine definition. Frontend machines run applications
# which serve web pages to users.
#
# === Parameters
#
# [*apps*]
#   An array of which applications should be running on the machine.
#
class govuk::node::s_frontend (
  $apps = [],
) inherits govuk::node::s_base {
  validate_array($apps)

  include govuk::node::s_ruby_app_server

  include $apps

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
