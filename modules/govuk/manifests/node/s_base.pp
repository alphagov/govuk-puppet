class govuk::node::s_base {
  include assets::user
  include backup::client
  include base
  include fail2ban
  include govuk::deploy
  include govuk::envsys
  include govuk::firewall
  include govuk::repository
  include govuk::scripts
  include govuk::sshkeys
  include harden
  include hosts
  include monitoring::client
  include postfix
  include puppet
  include puppet::cronjob
  include rbenv
  include rkhunter
  include ruby::rubygems
  include users
  include resolvconf

  rbenv::version { '1.9.3-p392':
    bundler_version => '1.3.5'
  }
  rbenv::version { '1.9.3-p484':
    bundler_version => '1.3.5'
  }
  rbenv::version { '1.9.3-p545':
    bundler_version => '1.3.5'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p545',
  }

  rbenv::version { '2.0.0-p247':
    bundler_version => '1.3.5'
  }
  rbenv::version { '2.0.0-p353':
    bundler_version => '1.3.5'
  }
  rbenv::version { '2.0.0-p451':
    bundler_version => '1.5.3'
  }
  rbenv::alias { '2.0.0':
    to_version => '2.0.0-p451',
  }

  rbenv::version { '2.1.2':
    bundler_version => '1.6.2'
  }
  rbenv::alias { '2.1':
    to_version => '2.1.2'
  }

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
}
