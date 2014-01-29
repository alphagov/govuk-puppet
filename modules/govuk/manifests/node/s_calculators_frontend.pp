class govuk::node::s_calculators_frontend inherits govuk::node::s_base {
  $protect_fe = str2bool(extlookup('protect_frontend_apps', 'no'))

  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::businesssupportfinder': vhost_protected => $protect_fe;
    'govuk::apps::calculators':           vhost_protected => $protect_fe;
    'govuk::apps::calendars':             vhost_protected => $protect_fe;
    'govuk::apps::fco_services':          vhost_protected => $protect_fe;
    'govuk::apps::finder_frontend':       vhost_protected => $protect_fe;
    'govuk::apps::licencefinder':         vhost_protected => $protect_fe;
    'govuk::apps::smartanswers':          vhost_protected => $protect_fe;
    'govuk::apps::tariff':                vhost_protected => $protect_fe;
    'govuk::apps::transaction_wrappers':  vhost_protected => $protect_fe;
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  @@nagios::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target       => "${::fqdn_underscore}.nginx.nginx_connections-writing",
    warning      => 150,
    critical     => 250,
    desc         => 'nginx high conn writing - upstream indicator',
    host_name    => $::fqdn,
    notes_url    => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#nginx-high-conn-writing-upstream-indicator-check',
  }
}
