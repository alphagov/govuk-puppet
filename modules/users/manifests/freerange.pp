class users::freerange {
  include users::setup
  user { 'tomw':
    ensure     => present,
    comment    => 'Tom Ward (tom.ward@gofreerange.co.uk)',
    home       => '/home/tomw',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { 'tomw':
    ensure  => present,
    key     => extlookup('tomw_key', ''),
    type    => 'ssh-rsa',
    user    => 'tomw',
    require => User['tomw']
  }

  user { 'chrisroos':
    ensure     => present,
    comment    => 'Chris Roos <chris.roos@gofreerange.com>',
    home       => '/home/chrisroos',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'chrisroos_key':
    ensure  => present,
    key     => extlookup('chrisroos_key', ''),
    type    => 'ssh-rsa',
    user    => 'chrisroos',
    require => User['chrisroos'],
  }

  user { 'jasoncale':
    ensure     => absent,
  }
  ssh_authorized_key { 'jasoncale':
    ensure  => absent,
  }

  user { 'jamesmead':
    ensure     => present,
    comment    => 'James Mead (james@floehopper.org)',
    home       => '/home/jamesmead',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jamesmead_key1':
    ensure  => present,
    key     => extlookup('jamesmead_key', ''),
    type    => 'ssh-rsa',
    user    => 'jamesmead',
    require => User['jamesmead']
  }

  user { 'lazyatom':
    ensure     => present,
    comment    => 'James Adam (james.adam@gofreerange.com)',
    home       => '/home/lazyatom',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'lazyatom_key1':
    ensure  => present,
    key     => extlookup('lazyatom_key', ''),
    type    => 'ssh-rsa',
    user    => 'lazyatom',
    require => User['lazyatom']
  }

  ssh_authorized_key {
    'deploy_key_jamesmead':
      ensure  => present,
      key     => extlookup('jamesmead_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_lazyatom':
      ensure  => present,
      key     => extlookup('lazyatom_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_chrisroos':
      ensure  => present,
      key     => extlookup('chrisroos_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_tomw':
      ensure  => present,
      key     => extlookup('tomw_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
  }

}
