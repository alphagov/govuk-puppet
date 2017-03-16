# == Class: govuk::node::s_monitoring
#
# This class sets up a monitoring machine.
#
# === Parameters
#
# [*enable_fastly_metrics*]
#   Boolean, whether collectd should pull metrics using Fastly's API
#
# [*offsite_backups*]
#   Boolean, whether the offsite backup machines should be monitored
#
class govuk::node::s_monitoring (
  $enable_fastly_metrics = false,
  $offsite_backups = true,
) inherits govuk::node::s_base {

  validate_bool($enable_fastly_metrics, $offsite_backups)

  include govuk_rbenv::all
  include ::govuk_testing_tools::smokey
  include monitoring

  if $enable_fastly_metrics {
    include collectd::plugin::cdn_fastly
  }

  nginx::config::vhost::proxy { 'graphite':
    to           => ['graphite.cluster'],
    aliases      => ['graphite.*', 'grafana', 'grafana.*'],
    ssl_only     => true,
    ssl_certtype => 'wildcard_publishing',
    protected    => false,
    root         => '/dev/null',
  }

  limits::limits { 'nagios_nofile':
    ensure     => present,
    user       => 'nagios',
    limit_type => 'nofile',
    both       => 16384,
  }

  file { '/opt/smokey':
    ensure => 'directory',
    owner  => 'deploy',
    group  => 'deploy',
  }

}
