class users::opg {
  include users::setup

  user { 'alister':
    ensure     => present,
    comment    => 'Alister Bulman (alister.bulman@betransformative.com)',
    home       => '/home/alister',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'alister_key1':
    ensure  => present,
    key     => extlookup('alister_key', ''),
    type    => 'ssh-rsa',
    user    => 'alister',
    require => User['alister']
  }

  user { 'chrismo2012':
    ensure     => present,
    comment    => 'Chris Moreton (chris.moreton@betransformative.com)',
    home       => '/home/chrismo2012',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'chrismo2012_key1':
    ensure  => present,
    key     => extlookup('chrismo2012_key', ''),
    type    => 'ssh-rsa',
    user    => 'chrismo2012',
    require => User['chrismo2012']
  }

  user { 'jamie':
    ensure     => present,
    comment    => 'jamie (Jamie.Burns@betransformative.com)',
    home       => '/home/jamie',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jamie_key1':
    ensure  => present,
    key     => extlookup('jamie_key', ''),
    type    => 'ssh-rsa',
    user    => 'jamie',
    require => User['jamie']
  }
}
