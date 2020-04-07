# == Class: monitoring::uptime_collector
#
# Set up the uptime monitoring tool.
#
# === Parameters
#
# [*environment*]
#   The environment the uptime collecting is running in. For example:
#     production, integration or staging.
#
# [*aws*]
#   Optional. True or false, depending on whether we're running in AWS or not.

class monitoring::uptime_collector (
  $environment = '',
  $aws = false,
) {
  exec { 'install statsd into 2.6 rbenv':
    environment => 'RBENV_VERSION=2.6',
    path        => ['/usr/lib/rbenv/shims', '/usr/local/bin', '/usr/bin', '/bin'],
    command     => 'gem install statsd-ruby',
    unless      => 'gem list -i statsd-ruby',
    notify      => Service['govuk-uptime-collector'],
  }

  file { '/usr/local/bin/govuk_uptime_collector':
    source => 'puppet:///modules/monitoring/usr/local/bin/govuk_uptime_collector',
    mode   => '0755',
    notify => Service['govuk-uptime-collector'],
  }

  file { '/etc/init/govuk-uptime-collector.conf':
    content => template('monitoring/govuk-uptime-collector.conf.erb'),
    notify  => Service['govuk-uptime-collector'],
  }

  service { 'govuk-uptime-collector':
    ensure => running,
    enable => true,
  }

  @@icinga::check { 'check_uptime_collector_running':
    check_command       => 'check_nrpe!check_proc_running_with_arg!ruby /usr/local/bin/govuk_uptime_collector',
    service_description => 'govuk_uptime_collector not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(uptime-metrics),
  }
}
