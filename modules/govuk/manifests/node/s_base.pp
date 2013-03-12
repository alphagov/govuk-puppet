class govuk::node::s_base {
  include assets::user
  include backup::client
  include base
  include fail2ban
  include govuk::deploy
  include govuk::envsys
  include govuk::repository
  include govuk::scripts
  include govuk::sshkeys
  include hosts
  include monitoring::client
  include puppet
  include puppet::cronjob
  include resolvconf
  include rkhunter
  include users

  # Enable management of groups specified in extdata
  $user_groups = extlookup("user_groups", [])
  $user_groups_real = regsubst($user_groups, '^', 'users::groups::')
  class { $user_groups_real: }

  class { 'rsyslog::client':
    server    => 'logging.cluster',
    log_local => true,
  }
  rsyslog::snippet { '10-ratelimit':
    content => '$SystemLogRateLimitInterval 0'
    }
  rsyslog::snippet { '39-audispd':
    content => ':programname, isequal, "audispd"  ~'
    }

  govuk::logstream {
    'apt-history':
      logfile => "/var/log/apt/history.log",
      tags    => ['apt','history'];
    'apt-term':
      logfile => "/var/log/apt/term.log",
      tags    => ['apt','term'];
    'dpkg':
      logfile => "/var/log/dpkg.log",
      tags    => ['dpkg'];
    'unattended-upgrades':
      logfile => "/var/log/unattended-upgrades/unattended-upgrades.log",
      tags    => ['apt','unattended'];
    'unattended-upgrades-shutdown':
      logfile => "/var/log/unattended-upgrades/unattended-upgrades-shutdown.log",
      tags    => ['apt','unattended'];
    'rkhunter':
      logfile => "/var/log/rkhunter.log",
      tags    => ['rkhunter'];
  }

  class { 'postfix':
    smarthost       => extlookup('postfix_smarthost', ''),
    smarthost_user  => extlookup('postfix_smarthost_user', ''),
    smarthost_pass  => extlookup('postfix_smarthost_pass', ''),
  }

  class { 'ruby::rubygems':
    version => '1.8.24',
  }

  case $::govuk_provider {
    'sky': {
      include govuk::firewall
      include harden

      # Start explanation of setting user passwords

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

      # End explanation
    }
    default: {}
  }
}
