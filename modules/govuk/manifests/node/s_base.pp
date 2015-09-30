# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_base {
  include assets::user
  include backup::client
  include base
  include fail2ban
  include govuk::deploy
  include govuk::envsys
  include govuk::firewall
  include govuk::safe_to_reboot
  include govuk::scripts
  include govuk::sshkeys
  include govuk_unattended_reboot
  include grub2
  include harden
  include hosts
  include monitoring::client
  include postfix
  include puppet
  include puppet::cronjob
  include govuk_rbenv
  include rcs
  include rkhunter
  include users
  include resolvconf

  class { 'rsyslog':
    purge_rsyslog_d => true,
    preserve_fqdn   => true,
  }

  class { 'rsyslog::client':
    server    => 'logging.cluster',
    log_local => true,
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
