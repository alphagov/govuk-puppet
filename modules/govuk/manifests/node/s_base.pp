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
  include puppet
  include puppet::cronjob
  include rbenv
  include rkhunter
  include users

  class { 'resolvconf':
    nameservers => extlookup('resolvconf_nameservers', []),
  }

  rbenv::version { '1.9.3-p392':
    bundler_version => '1.3.5'
  }
  rbenv::version { '1.9.3-p484':
    bundler_version => '1.3.5'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p392',
  }
  rbenv::version { '2.0.0-p247':
    bundler_version => '1.3.5'
  }

  # Enable management of groups specified in extdata
  $user_groups = extlookup('user_groups', [])
  $user_groups_real = regsubst($user_groups, '^', 'users::groups::')
  class { $user_groups_real: }

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

  rsyslog::snippet { '100-ratelimit':
    content => '$SystemLogRateLimitInterval 0'
  }

  rsyslog::snippet { '100-preservefqdn':
    content => '$PreserveFQDN on',
  }

  rsyslog::snippet { '410-audispd':
    content => ':programname, isequal, "audispd"  ~'
  }

  rsyslog::snippet { '490-client-programs':
    content => template('govuk/etc/rsyslog.d/490-client-programs.conf.erb'),
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

  class { 'postfix':
    smarthost       => extlookup('postfix_smarthost', ''),
    smarthost_user  => extlookup('postfix_smarthost_user', ''),
    smarthost_pass  => extlookup('postfix_smarthost_pass', ''),
  }

  class { 'ruby::rubygems':
    version => '1.8.24',
  }

  # whoopsie is the ubuntu crash reporter. We don't want to be running any
  # software that sends data from our machines to 3rd-party services. Remove it.
  package { 'whoopsie':
    ensure => purged,
  }

  # TL;DR:
  # Setting ubuntu password will silently fail on the first run of puppet.
  # Details:
  # On the first run of puppet, ruby-libshadow is not installed when
  # puppet is started by Ruby. This means that the User provider does
  # not have the ability to set passwords. We install the libshadow gem
  # during the puppet run, but Ruby is not re-executed, so the running
  # puppet process still does not have the ability to set the 'ubuntu'
  # password. On the second run of puppet, the password for the ubuntu
  # user will be set.
  user { 'ubuntu':
    ensure   => present,
    password => extlookup('ubuntu_pass_hash','!!'),
    groups   => ['admin'],
    require  => Group['admin'];
  }
}
