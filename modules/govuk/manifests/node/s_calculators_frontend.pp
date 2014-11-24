# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_calculators_frontend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  include govuk::apps::businesssupportfinder
  include govuk::apps::calculators
  include govuk::apps::calendars
  include govuk::apps::finder_frontend
  include govuk::apps::licencefinder
  include govuk::apps::smartanswers
  include govuk::apps::tariff

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
