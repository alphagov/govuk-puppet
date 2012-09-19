class govuk_node::base {
  include ::base
  include hosts
  include monitoring::client
  include puppet
  include puppet::cronjob
  include users
  include users::groups::bitzesty
  include users::groups::freerange
  include users::groups::govuk
  include users::groups::newbamboo
  include users::groups::other

  #Security additions
  include rkhunter
  include fail2ban

  include govuk::repository
  include govuk::deploy

  class { 'ruby::rubygems':
    version => '1.8.24'
  }

  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='
  }

  case $::govuk_provider {
    'sky': {
      include ufw::govuk
      include harden
      include apt_cacher::client

      user { 'ubuntu':
        ensure   => present,
        password => extlookup('ubuntu_pass_hash','!!'),
        groups   => ['admin'],
        require  => Group['admin'];
      }
    }
    'scc': {
      include ufw::govuk
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
