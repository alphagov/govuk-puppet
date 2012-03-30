class users {
  include users::setup
  include users::govuk
}

class users::setup {
  include shell
  package { 'zsh':
    ensure => latest,
  }
  group { 'admin':
    name        => 'admin',
    gid         => '3000',
  }
  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    shell       => '/bin/bash'
  }
  file { '/data':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0755',
    require => User['deploy'],
  }
  ssh_authorized_key {
    'deploy_key_minglis':
      ensure  => present,
      key     => extlookup('minglis_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_heathd':
      ensure  => present,
      key     => extlookup('heathd_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_fberriman':
      ensure  => present,
      key     => extlookup('fberriman_key', ''),
      type    => 'ssh-dss',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_paulb':
      ensure  => present,
      key     => extlookup('paulb_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_garethr':
      ensure  => present,
      key     => extlookup('garethr_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_james':
      ensure  => present,
      key     => extlookup('james_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_mwall':
      ensure  => present,
      key     => extlookup('mwall_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jordanh':
      ensure  => present,
      key     => extlookup('jordanh_key', ''),
      type    => 'ssh-dss',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_dafydd':
      ensure  => present,
      key     => extlookup('dafydd_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jenkins':
      ensure  => present,
      key     => extlookup('jenkins_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jamesweiner':
      ensure  => present,
      key     => extlookup('jamesweiner_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_davidt':
      ensure => present,
      key => extlookup('davidt_key', ''),
      type => 'ssh-rsa',
      user => 'deploy',
      require => User['deploy'];
    'deploy_key_mazz':
      ensure => present,
      key => extlookup('mazz_key', ''),
      type => 'ssh-rsa',
      user => 'deploy',
      require => User['deploy'];
    }
}

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
    comment    => "David Thompson <david.thompson@digital.cabinet-office.gov.uk>",
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
    comment    => "Mazz Mosley <mazz.mosley@digital.cabinet-office.gov.uk>",
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
}


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
    ensure     => present,
    comment    => 'Jason Cale <jason.cale@gofreerange.com>',
    home       => '/home/jasoncale',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'jasoncale':
    ensure  => present,
    key     => extlookup('jasoncale_key', ''),
    type    => 'ssh-rsa',
    user    => 'jasoncale',
    require => User['jasoncale'],
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
    'deploy_key_jasoncale':
      ensure  => present,
      key     => extlookup('jasoncale_key', ''),
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

# Office of the public guardian, LPA project
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
