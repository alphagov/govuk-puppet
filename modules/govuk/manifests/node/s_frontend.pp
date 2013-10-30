class govuk::node::s_frontend inherits govuk::node::s_base {
  $protect_fe = str2bool(extlookup('protect_frontend_apps', 'no'))

  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::datainsight_frontend':  vhost_protected => $protect_fe;
    'govuk::apps::designprinciples':      vhost_protected => $protect_fe;
    'govuk::apps::feedback':              vhost_protected => $protect_fe;
    'govuk::apps::frontend':              vhost_protected => $protect_fe;
    'govuk::apps::limelight':             vhost_protected => $protect_fe;
    'govuk::apps::specialist_frontend':   vhost_protected => $protect_fe;
  }

  include govuk::apps::canary_frontend
  include govuk::apps::static
  include govuk::apps::transactions_explorer

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target       => "${::fqdn_underscore}.nginx.nginx_connections-writing",
    warning      => 150,
    critical     => 250,
    desc         => 'nginx high conn writing - upstream indicator',
    host_name    => $::fqdn,
    notes_url    => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#nginx-high-conn-writing-upstream-indicator-check',
  }
}
