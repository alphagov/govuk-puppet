class govuk::node::s_bouncer (
  $app_basic_auth = false
) inherits govuk::node::s_base {

  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::bouncer':               vhost_protected => $app_basic_auth;
  }

  include nginx

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target       => "${::fqdn_underscore}.nginx.nginx_connections-writing",
    warning      => 150,
    critical     => 250,
    desc         => 'nginx high conn writing - upstream indicator',
    host_name    => $::fqdn,
    notes_url    => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#nginx-high-conn-writing-upstream-indicator-check',
  }
}
