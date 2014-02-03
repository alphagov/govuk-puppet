# == Class: puppet::monitoring
#
# Monitoring for Puppet agents.
#
class puppet::monitoring {
  file { '/usr/local/bin/puppet_passive_check_update':
    ensure  => present,
    mode    => '0755',
    content => template('puppet/puppet_passive_check_update'),
  }

  @icinga::plugin { 'check_puppet_agent':
    source  => 'puppet:///modules/puppet/usr/lib/nagios/plugins/check_puppet_agent',
  }

  @@icinga::passive_check { "check_puppet_${::hostname}":
    service_description => 'puppet last run errors',
    host_name           => $::fqdn,
    freshness_threshold => 7200,
  }
}
