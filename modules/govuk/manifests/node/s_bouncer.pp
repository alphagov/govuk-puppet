class govuk::node::s_bouncer inherits govuk::node::s_base {
  $protect_fe = str2bool(extlookup('protect_frontend_apps', 'no'))

  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::bouncer':               vhost_protected => $protect_fe;
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

  @@icinga::check::graphite { "check_bouncer_501s_${::hostname}":
    target    => "transformNull(stats.${::fqdn_underscore}.nginx_logs.bouncer_*.http_501,0)",
    warning   => 0.000001,
    critical  => 0.000002,
    from      => '1hour',
    desc      => 'bouncer 501s: indicates bouncer misconfiguration',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#bouncer-501s',
  }
}
