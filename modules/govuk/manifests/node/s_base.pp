# == Class: govuk::node::s_base
#
# Base node definition. Every machine inherits from this.
#
# === Parameters
#
# [*node_apps*]
#   A hash of GOV.UK applications that run on a node class.
#
# [*log_remote*]
#   Whether to enable sending syslogs to remote syslog server. Parameter should
#   be removed when we have fully migrated to using Filebeat for shipping logs.
#
class govuk::node::s_base (
  $node_apps = {},
  $log_remote = true,
) {
  validate_hash($node_apps)

  include backup::client
  include base
  include govuk_beat
  include govuk_firewall
  include govuk_harden
  include govuk_safe_to_reboot
  include govuk_rbenv
  include grub2
  include ::limits
  include monitoring::client
  include postfix
  include rcs

  if ! $::aws_migration {
    include hosts
  }

  if $::aws_migration {
    $_node_class = $::aws_migration
  } else {
    $_hostname = regsubst($::fqdn_short, '-\d\..*$', '')
    $_node_class = regsubst($_hostname, '-', '_', 'G')
  }

  $node_class = $node_apps[$_node_class]

  unless empty($node_class) {
    $_apps = $node_class['apps']
    $apps = regsubst($_apps, '-', '_', 'G')

    $app_classes = regsubst($apps, '^', 'govuk::apps::')

    include $app_classes
  }

  class { 'rsyslog':
    preserve_fqdn   => true,
    purge_rsyslog_d => true,
  }

  if $::aws_migration {
    $logging_hostname = 'logging'
  } else {
    $logging_hostname = 'logging.cluster'
  }

  if $log_remote {
    class { 'rsyslog::client':
      server    => $logging_hostname,
      log_local => true,
    }
  } else {
    # Syslogs are collected by Filebeat
    class { 'rsyslog::client':
      log_local  => true,
      log_remote => false,
    }
  }

  # Enable default tcpconn monitoring for port 22
  collectd::plugin::tcpconn { 'ssh':
    incoming => 22,
    outgoing => 22,
  }

  # Introducing rsyslog::snippet for custom config files
  # for rsyslogs

  rsyslog::snippet { 'aaa-disable-ratelimit':
    content => '$SystemLogRateLimitInterval 0',
  }

  rsyslog::snippet { 'aaa-disable-remote-audispd':
    content => ':programname, isequal, "audispd"  stop',
  }

  rsyslog::snippet { 'aaa-local3-for-govuk-apps':
    content => template('govuk/etc/rsyslog.d/local3-for-govuk-apps.conf.erb'),
    require => File['govuk-log-dir'],
  }

  file { 'govuk-log-dir':
    ensure => directory,
    path   => '/var/log/govuk',
  }

  @logrotate::conf { 'govuk-logs':
    matches => '/var/log/govuk/*.log',
  }

  # whoopsie is the ubuntu crash reporter. We don't want to be running any
  # software that sends data from our machines to 3rd-party services. Remove it.
  package { 'whoopsie':
    ensure => purged,
  }

  # Remove user on first Puppet run after bootstrapping.
  user { 'ubuntu':
    ensure => absent,
  }
}
