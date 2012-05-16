class users::govuk {
  user { 'craig':
    ensure     => absent
  }

  user { 'mwall':
    ensure     => present,
    comment    => 'Mat Wall (mat.wall@digital.cabinet-office.gov.uk)',
    home       => '/home/mwall',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'mwall_key1':
    ensure  => present,
    key     => extlookup('mwall_key', ''),
    type    => 'ssh-rsa',
    user    => 'mwall',
    require => User['mwall']
  }

  user { 'minglis':
    ensure     => present,
    comment    => 'Martyn Inglis (martyn.inglis@digital.cabinet-office.gov.uk)',
    home       => '/home/minglis',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'minglis_key':
    ensure  => present,
    key     => extlookup('minglis_key', ''),
    type    => 'ssh-rsa',
    user    => 'minglis',
    require => User['minglis']
  }

  user { 'dafydd':
    ensure     => present,
    comment    => 'Dafydd Vaughan (dafydd.vaughan@digital.cabinet-office.gov.uk)',
    home       => '/home/dafydd',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'dafydd_key1':
    ensure  => present,
    key     => extlookup('dafydd_key', ''),
    type    => 'ssh-rsa',
    user    => 'dafydd',
    require => User['dafydd']
  }

  user { 'garethr':
    ensure     => present,
    comment    => 'Gareth Rushgrove (gareth.rushgrove@digital.cabinet-office.gov.uk)',
    home       => '/home/garethr',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { 'garethr_key1':
    ensure  => present,
    key     => extlookup('garethr_key', ''),
    type    => 'ssh-rsa',
    user    => 'garethr',
    require => User['garethr']
  }

  user { 'heathd':
    ensure     => present,
    comment    => 'David Heath (david.heath@digital.cabinet-office.gov.uk)',
    home       => '/home/heathd',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'heathd_key1':
    ensure  => present,
    key     => extlookup('heathd_key', ''),
    type    => 'ssh-rsa',
    user    => 'heathd',
    require => User['heathd']
  }

  user { 'james':
    ensure     => present,
    comment    => 'James Stewart (james.stewart@digital.cabinet-office.gov.uk)',
    home       => '/home/james',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'james_key1':
    ensure  => present,
    key     => extlookup('james_key', ''),
    type    => 'ssh-rsa',
    user    => 'james',
    require => User['james']
  }

  user { 'joshua':
    ensure     => present,
    comment    => 'Joshua Marshall (joshua.marshall@digital.cabinet-office.gov.uk)',
    home       => '/home/joshua',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'joshua_key1':
    ensure  => present,
    key     => extlookup('joshua_key', ''),
    type    => 'ssh-rsa',
    user    => 'joshua',
    require => User['joshua']
  }

  user { 'paulb':
    ensure     => present,
    comment    => 'Paul Battley <paul.battley@digital.cabinet-office.gov.uk>',
    home       => '/home/paulb',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/tcsh'
  }
  ssh_authorized_key { 'paulb_kurosuke':
    ensure  => present,
    key     => extlookup('paulb_key', ''),
    type    => 'ssh-rsa',
    user    => 'paulb',
    require => User['paulb'],
  }

  user { 'davidt':
    ensure     => present,
    comment    => 'David Thompson <david.thompson@digital.cabinet-office.gov.uk>',
    home       => '/home/davidt',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'davidt':
    ensure  => present,
    key     => extlookup('davidt_key', ''),
    type    => 'ssh-rsa',
    user    => 'davidt',
    require => User['davidt']
  }
  user { 'mazz':
    ensure     => present,
    comment    => 'Mazz Mosley <mazz.mosley@digital.cabinet-office.gov.uk>',
    home       => '/home/mazz',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'mazz':
    ensure  => present,
    key     => extlookup('mazz_key', ''),
    type    => 'ssh-rsa',
    user    => 'mazz',
    require => User['mazz']
  }

  user { 'jamesweiner':
    ensure     => present,
    comment    => 'James Weiner <james.weiner@digital.cabinet-office.gov.uk>',
    home       => '/home/jamesweiner',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jamesweiner':
    ensure  => present,
    key     => extlookup('jamesweiner_key', ''),
    type    => 'ssh-rsa',
    user    => 'jamesweiner',
    require => User['jamesweiner']
  }
  user { 'robyoung':
    ensure     => present,
    comment    => 'Rob Young <rob.young@digital.cabinet-office.gov.uk>',
    home       => '/home/robyoung',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'robyoung':
    ensure  => present,
    key     => extlookup('robyoung_key', ''),
    type    => 'ssh-rsa',
    user    => 'robyoung',
    require => User['robyoung']
  }

  user { 'jabley':
    ensure     => present,
    comment    => 'James Abley <james.abley@digital.cabinet-office.gov.uk>',
    home       => '/home/jabley',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jabley':
    ensure  => present,
    key     => extlookup('jabley_key', ''),
    type    => 'ssh-rsa',
    user    => 'jabley',
    require => User['jabley']
  }

  user { 'jamiec':
    ensure     => present,
    comment    => 'Jamie Cobbett <jamie.cobbett@digital.cabinet-office.gov.uk>',
    home       => '/home/jamiec',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jamiec':
    ensure  => present,
    key     => extlookup('jamiecobbett_key', ''),
    type    => 'ssh-rsa',
    user    => 'jamiec',
    require => User['jamiec']
  }
}
