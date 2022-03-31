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

  include govuk_chromedriver
  include govuk_rbenv::all
  include ::govuk_cdnlogs
  include monitoring
  include collectd::plugin::icinga
  include govuk_java::openjdk8::jre
  include govuk_java::openjdk8::jdk
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk8',
    jre => 'openjdk8',
  }

  if $enable_fastly_metrics {
    include collectd::plugin::cdn_fastly
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

  package { 'redis-tools':
    ensure => installed,
  }
}
