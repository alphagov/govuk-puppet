class govuk::node::s_base {

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
  include rkhunter
  include users
  include users::assets
  include users::groups::bitzesty
  include users::groups::govuk
  include users::groups::newbamboo
  include users::groups::other
  include users::groups::freerange

  $email_collection = extlookup('email_collection','off')
  case $email_collection {
    "on":     {
        include postfix
    }
    default : {}
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
