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

  $app_domain = hiera('app_domain')
  $kibana_url = "https://kibana.${app_domain}"

  # FIXME: Use `fqdn` instead of `hostname`.
  # https://www.pivotaltracker.com/story/show/47708141
  $kibana_search = {
    'query' => "@fields.syslog_program:'puppet-agent' AND @source_host:${::hostname}*",
    'from'  => '4h',
  }

  @@icinga::passive_check { "check_puppet_${::hostname}":
    service_description => 'puppet last run errors',
    host_name           => $::fqdn,
    freshness_threshold => 7200,
    action_url          => kibana3_url($kibana_url, $kibana_search),
    notes_url           => monitoring_docs_url(puppet-last-run-errors),
  }
}
