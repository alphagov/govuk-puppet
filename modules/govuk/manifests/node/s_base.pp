# == Class: govuk::node::s_base
#
# Base node definition. Every machine inherits from this.
#
# === Parameters
#
# [*apps*]
#   An array of GOV.UK applications that should be included on this machine.
#
class govuk::node::s_base (
  $apps = [],
) {
  validate_array($apps)

  include backup::client
  include base
  include fail2ban
  include govuk::firewall
  include govuk::safe_to_reboot
  include govuk_unattended_reboot
  include grub2
  include harden
  include hosts
  include ::limits
  include monitoring::client
  include postfix
  include puppet::cronjob
  include rcs
  include rkhunter

  $app_classes = regsubst($apps, '^', 'govuk::apps::')
  include $app_classes

  class { 'rsyslog':
    purge_rsyslog_d => true,
  }

  class { 'rsyslog::client':
    server        => 'logging.cluster',
    log_local     => true,
    preserve_fqdn => true,
  }

  # Enable default tcpconn monitoring for port 22
  collectd::plugin::tcpconn { 'ssh':
    incoming => 22,
    outgoing => 22,
  }

  # Introducing rsyslog::snippet for custom config files
  # for rsyslogs

  rsyslog::snippet { 'aaa-disable-ratelimit':
    content => '$SystemLogRateLimitInterval 0'
  }

  rsyslog::snippet { 'aaa-disable-remote-audispd':
    content => ':programname, isequal, "audispd"  ~'
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

  govuk::logstream {
    'apt-history':
      logfile => '/var/log/apt/history.log',
      tags    => ['history'],
      fields  => {'application' => 'apt'};
    'apt-term':
      logfile => '/var/log/apt/term.log',
      tags    => ['term'],
      fields  => {'application' => 'apt'};
    'dpkg':
      logfile => '/var/log/dpkg.log',
      fields  => {'application' => 'dpkg'};
    'unattended-upgrades':
      logfile => '/var/log/unattended-upgrades/unattended-upgrades.log',
      tags    => ['unattended'],
      fields  => {'application' => 'apt'};
    'unattended-upgrades-shutdown':
      logfile => '/var/log/unattended-upgrades/unattended-upgrades-shutdown.log',
      tags    => ['unattended'],
      fields  => {'application' => 'apt'};
    'rkhunter':
      logfile => '/var/log/rkhunter.log',
      fields  => {'application' => 'rkhunter'};
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

  # FIXME: Mitigation for: http://www.ubuntu.com/usn/usn-2643-1/
  #        Remove when we have rebooted all machines
  file { '/etc/modprobe.d/blacklist-overlayfs.conf':
    ensure  => file,
    content => "blacklist overlayfs\n",
  }
}
