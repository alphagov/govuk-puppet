class users::govuk {
  user { 'craig': ensure => absent }
  user { 'paulb': ensure => absent }

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

  user { 'davidillsley':
    ensure     => present,
    comment    => 'David Illsley (david.illsley@digital.cabinet-office.gov.uk)',
    home       => '/home/davidillsley',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'davidillsley_key':
    ensure  => present,
    key     => extlookup('davidillsley_key', ''),
    type    => 'ssh-rsa',
    user    => 'davidillsley',
    require => User['davidillsley']
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
  ssh_authorized_key { 'davidt_gds':
    ensure  => present,
    key     => extlookup('davidt_gds_key', ''),
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
  user { 'annashipman':
    ensure     => present,
    comment    => 'Anna Shipman <anna.shipman@digital.cabinet-office.gov.uk>',
    home       => '/home/annashipman',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'annashipman':
    ensure  => present,
    key     => extlookup('annashipman_key', ''),
    type    => 'ssh-rsa',
    user    => 'annashipman',
    require => User['annashipman']
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
    key     => extlookup('jamiec_key', ''),
    type    => 'ssh-rsa',
    user    => 'jamiec',
    require => User['jamiec']
  }

  user { 'kushalp':
    ensure     => present,
    comment    => 'Kushal Pisavadia <kushal.pisavadia@digital.cabinet-office.gov.uk>',
    home       => '/home/kushalp',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'kushalp':
    ensure  => present,
    key     => extlookup('kushalp_key', ''),
    type    => 'ssh-rsa',
    user    => 'kushalp',
    require => User['kushalp']
  }

  user { 'bradleyw':
    ensure     => present,
    comment    => 'Bradley Wright <bradley.wright@digital.cabinet-office.gov.uk>',
    home       => '/home/bradleyw',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'bradleyw':
    ensure  => present,
    key     => extlookup('bradleyw_key', ''),
    type    => 'ssh-rsa',
    user    => 'bradleyw',
    require => User['bradleyw']
  }

  user { 'ppotter':
    ensure     => present,
    comment    => 'Philip Potter <philip.potter@digital.cabinet-office.gov.uk>',
    home       => '/home/ppotter',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'ppotter':
    ensure  => present,
    key     => extlookup('ppotter_key', ''),
    type    => 'ssh-rsa',
    user    => 'ppotter',
    require => User['ppotter']
  }

  user { 'ssharpe':
    ensure     => present,
    comment    => 'Sam Sharpe <sam.sharpe@digital.cabinet-office.gov.uk>',
    home       => '/home/ssharpe',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'ssharpe':
    ensure  => present,
    key     => extlookup('ssharpe_key', ''),
    type    => 'ssh-rsa',
    user    => 'ssharpe',
    require => User['ssharpe']
  }
  user { 'carlmassa':
    ensure     => present,
    comment    => 'Carl Massa <carl.massa@digital.cabinet-office.gov.uk>',
    home       => '/home/carlmassa',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'carlmassa':
    ensure  => present,
    key     => extlookup('carlmassa_key', ''),
    type    => 'ssh-rsa',
    user    => 'carlmassa',
    require => User['carlmassa']
  }
  user { 'eddsowden':
    ensure     => present,
    comment    => 'Edd Sowden <edd.sowden@digital.cabinet-office.gov.uk>',
    home       => '/home/eddsowden',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'eddsowden':
    ensure  => present,
    key     => extlookup('eddsowden_key', ''),
    type    => 'ssh-rsa',
    user    => 'eddsowden',
    require => User['eddsowden']
  }
  user { 'tombyers':
    ensure     => present,
    comment    => 'Tom Byers <tom.byers@digital.cabinet-office.gov.uk>',
    home       => '/home/tombyers',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'tombyers':
    ensure  => present,
    key     => extlookup('tombyers_key', ''),
    type    => 'ssh-rsa',
    user    => 'tombyers',
    require => User['tombyers']
  }
  user { 'nick':
    ensure     => present,
    comment    => 'Nick Stenning <nick.stenning@digital.cabinet-office.gov.uk>',
    home       => '/home/nick',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { 'nick':
    ensure  => present,
    key     => extlookup('nick_key', ''),
    type    => 'ssh-rsa',
    user    => 'nick',
    require => User['nick']
  }
  user { 'chrisheathcote':
    ensure     => present,
    comment    => 'Chris Heathcote <chris.heathcote@digital.cabinet-office.gov.uk>',
    home       => '/home/chrisheathcote',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { 'chrisheathcote':
    ensure  => present,
    key     => extlookup('chrisheathcote_key', ''),
    type    => 'ssh-rsa',
    user    => 'chrisheathcote',
    require => User['chrisheathcote']
  }
  user { 'johngriffin':
    ensure     => present,
    comment    => 'John Griffin <john.griffin@digital.cabinet-office.gov.uk>',
    home       => '/home/johngriffin',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { 'johngriffin':
    ensure  => present,
    key     => extlookup('johngriffin_key', ''),
    type    => 'ssh-rsa',
    user    => 'johngriffin',
    require => User['johngriffin']
  }
  user { 'stevelaing':
    ensure     => present,
    comment    => 'Steve Laing <steve.laing@digital.cabinet-office.gov.uk>',
    home       => '/home/stevelaing',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { 'stevelaing':
    ensure  => present,
    key     => extlookup('stevelaing_key', ''),
    type    => 'ssh-rsa',
    user    => 'stevelaing',
    require => User['stevelaing']
  }
}
