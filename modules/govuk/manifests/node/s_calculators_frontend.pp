# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_calculators_frontend (
  #FIXME #73421574: remove when we are off old preview and it is no longer possible
  #       to access apps directly from the internet
  $app_basic_auth = false
) inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::businesssupportfinder': vhost_protected => $app_basic_auth;
    'govuk::apps::calculators':           vhost_protected => $app_basic_auth;
    'govuk::apps::calendars':             vhost_protected => $app_basic_auth;
    'govuk::apps::finder_frontend':       vhost_protected => $app_basic_auth;
    'govuk::apps::licencefinder':         vhost_protected => $app_basic_auth;
    'govuk::apps::smartanswers':          vhost_protected => $app_basic_auth;
    'govuk::apps::tariff':                vhost_protected => $app_basic_auth;
  }

  # FIXME: Remove once cleaned up from servers
  include govuk::apps::fco_services

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

  Govuk::Mount['/data/vhost'] -> Class['govuk::apps::calculators']

}
