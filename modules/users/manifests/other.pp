class users::other {
  user { 'tomstuart':
    ensure     => present,
    comment    => 'Tom Stuart <tom@experthuman.com>',
    home       => '/home/tomstuart',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'tomstuart_key1':
    ensure  => present,
    key     => extlookup('tomstuart_key', ''),
    type    => 'ssh-rsa',
    user    => 'tomstuart',
    require => User['tomstuart']
  }
  ssh_authorized_key { 'deploy_key_tomstuart':
    ensure  => present,
    key     => extlookup('tomstuart_key', ''),
    type    => 'ssh-rsa',
    user    => 'deploy',
    require => User['deploy'];
  }
}
