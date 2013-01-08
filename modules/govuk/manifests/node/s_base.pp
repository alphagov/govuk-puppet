class govuk::node::s_base {
  include backup::client
  include base
  include hosts
  include monitoring::client
  include puppet
  include puppet::cronjob
  include users
  include users::assets
  include users::groups::bitzesty
  include users::groups::govuk
  include users::groups::newbamboo
  include users::groups::other

  include govuk::deploy
  include govuk::repository

  # Security additions
  include fail2ban
  include govuk::deploy
  include govuk::repository
  include rkhunter

  case $::lsbdistcodename {
    precise: {}
    default: {
      class { 'ruby::rubygems':
        version => '1.8.24'
      }
    }
  }

  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => extlookup('github_key',''),
  }

  sshkey { 'github.gds':
    ensure => present,
    type   => 'ssh-rsa',
    key    => extlookup('github_gds_key',''),
  }

  case $::govuk_provider {
    'sky': {
      include apt_cacher::client
      include govuk::firewall
      include harden

      user { 'ubuntu':
        ensure   => present,
        password => extlookup('ubuntu_pass_hash','!!'),
        groups   => ['admin'],
        require  => Group['admin'];
      }
    }
    default: {}
  }
}
