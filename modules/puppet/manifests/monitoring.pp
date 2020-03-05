# == Class: puppet::monitoring
#
# Monitoring for Puppet agents.
#
# === Parameters:
#
# [*alert_hostname*]
#   The hostname of the alert service, to send ncsa notifications.
#
class puppet::monitoring (
  $alert_hostname = 'alert.cluster',
) {
  file { '/usr/local/bin/puppet_passive_check_update':
    ensure  => present,
    mode    => '0755',
    content => template('puppet/puppet_passive_check_update'),
  }

  @icinga::plugin { 'check_puppet_agent':
    source  => 'puppet:///modules/puppet/usr/lib/nagios/plugins/check_puppet_agent',
  }

  $app_domain = hiera('app_domain')

  @@icinga::passive_check { "check_puppet_${::hostname}":
    service_description   => 'puppet last run errors',
    host_name             => $::fqdn,
    freshness_threshold   => 7200,
    freshness_alert_level => 'critical',
    notes_url             => monitoring_docs_url(puppet-last-run-errors),
  }
}
