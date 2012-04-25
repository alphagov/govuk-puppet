class users::ertp {
  include users::setup

  user { 'jameshu':
    ensure     => present,
    comment    => 'James Hughes (j.hughes@kainos.com)',
    home       => '/home/jameshu',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jamehsu_key1':
    ensure  => present,
    key     => extlookup('jameshu_key', ''),
    type    => 'ssh-rsa',
    user    => 'jameshu',
    require => User['jameshu']
  }

  user { 'michaela':
    ensure     => present,
    comment    => 'Michael Allen (m.allen@kainos.com)',
    home       => '/home/michaela',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'michaela_key1':
    ensure  => present,
    key     => extlookup('michaela_key', ''),
    type    => 'ssh-rsa',
    user    => 'michaela',
    require => User['michaela']
  }

  user { 'leszekg':
    ensure     => present,
    comment    => 'Leszek Gonczar (l.gonczar@kainos.com)',
    home       => '/home/leszekg',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'leszekg_key1':
    ensure  => present,
    key     => extlookup('leszekg_key', ''),
    type    => 'ssh-rsa',
    user    => 'leszekg',
    require => User['leszekg']
  }
}
