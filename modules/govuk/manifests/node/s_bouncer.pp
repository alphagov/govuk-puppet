# == Class: govuk::node::s_bouncer
#
# Sets up a machine to run the bouncer app and redirect old domains
# to GOV.UK.
#
# === Parameters
#
# [*minimum_request_rate*]
#   The Graphite metric value for minimum number of requests that
#   we would expect to see.
#
class govuk::node::s_bouncer (
  $minimum_request_rate = 5,
) inherits govuk::node::s_base {

  include govuk_bouncer::gor
  include govuk::node::s_app_server
  include nginx

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target    => "${::fqdn_metrics}.nginx.nginx_connections-writing",
    warning   => 150,
    critical  => 250,
    desc      => 'nginx high conn writing - upstream indicator',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-high-conn-writing-upstream-indicator-check),
  }

  @@icinga::check::graphite { "check_nginx_requests_${::hostname}":
    target              => "${::fqdn_metrics}.nginx.nginx_requests",
    warning             => "@${minimum_request_rate * 1.2}",
    critical            => "@${minimum_request_rate}",
    desc                => 'Minimum HTTP request rate for bouncer',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(nginx-requests-too-low),
    notification_period => 'inoffice',
  }
}
