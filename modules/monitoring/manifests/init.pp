# == Class: monitoring
#
# Sets up monitoring.
#
# === Parameters:
#
# [*ci_environment*]
#   Disables lots of default alerts if this is the CI environment.
#
class monitoring (
  $ci_environment = false,
) {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include icinga
  include nsca::server

  include govuk_htpasswd

  unless $ci_environment {
    # Monitoring server only.
    include monitoring::contacts
    include monitoring::checks
    include monitoring::edge
    include monitoring::event_handlers
    include monitoring::pagerduty_drill
    include monitoring::uptime_collector
  }

  if ! $::aws_migration {
    include monitoring::vpn_gateways
  }

}
