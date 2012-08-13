class users::groups::govuk {

  govuk::user { 'craig': ensure => absent }
  govuk::user { 'paulb': ensure => absent }

  # Ensure defunct users are absent
  govuk::user { 'steve': ensure => absent }
  govuk::user { 'jgriffin':
    ensure => absent
  }

  govuk::user { 'mwall':
    fullname   => 'Mat Wall',
    email      => 'mat.wall@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'davidillsley':
    fullname   => 'David Illsley',
    email      => 'david.illsley@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'minglis':
    fullname   => 'Martyn Inglis',
    email      => 'martyn.inglis@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'dafydd':
    fullname   => 'Dafydd Vaughan',
    email      => 'dafydd.vaughan@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'dai':
    fullname   => 'Dafydd Vaughan',
    email      => 'dafydd.vaughan@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'garethr':
    fullname   => 'Gareth Rushgrove',
    email      => 'gareth.rushgrove@digital.cabinet-office.gov.uk',
    shell      => '/bin/zsh';
  }
  govuk::user { 'heathd':
    fullname   => 'David Heath',
    email      => 'david.heath@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'james':
    fullname   => 'James Stewart',
    email      => 'james.stewart@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'joshua':
    fullname   => 'Joshua Marshall',
    email      => 'joshua.marshall@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'davidt':
    fullname   => 'David Thompson',
    email      => 'david.thompson@digital.cabinet-office.gov.uk';
  }
  ssh_authorized_key { 'davidt_gds':
    ensure  => present,
    key     => extlookup('davidt_gds_key', ''),
    type    => 'ssh-rsa',
    user    => 'davidt',
    require => Govuk::User['davidt']
  }
  govuk::user { 'mazz':
    fullname   => 'Mazz Mosley',
    email      => 'mazz.mosley@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'annashipman':
    fullname   => 'Anna Shipman',
    email      => 'anna.shipman@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'jamesweiner':
    fullname   => 'James Weiner',
    email      => 'james.weiner@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'robyoung':
    fullname   => 'Rob Young',
    email      => 'rob.young@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'alext':
    fullname   => 'Alex Tomlins',
    email      => 'alex.tomlins@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'jabley':
    fullname   => 'James Abley',
    email      => 'james.abley@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'jamiec':
    fullname   => 'Jamie Cobbett',
    email      => 'jamie.cobbett@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'kushalp':
    fullname   => 'Kushal Pisavadia',
    email      => 'kushal.pisavadia@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'bradleyw':
    fullname   => 'Bradley Wright',
    email      => 'bradley.wright@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'psd':
    fullname   => 'Paul Downey',
    email      => 'paul.downey@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'ppotter':
    fullname   => 'Philip Potter',
    email      => 'philip.potter@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'ssharpe':
    fullname   => 'Sam Sharpe',
    email      => 'sam.sharpe@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'ukini':
    fullname   => 'Uttam Kini',
    email      => 'uttam.kini@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'carlmassa':
    fullname   => 'Carl Massa',
    email      => 'carl.massa@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'eddsowden':
    fullname   => 'Edd Sowden',
    email      => 'edd.sowden@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'tombyers':
    fullname   => 'Tom Byers',
    email      => 'tom.byers@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'nick':
    fullname   => 'Nick Stenning',
    email      => 'nick.stenning@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'chrisheathcote':
    fullname   => 'Chris Heathcote',
    email      => 'chris.heathcote@digital.cabinet-office.gov.uk',
    shell      => '/bin/zsh';
  }
  govuk::user { 'johngriffin':
    fullname   => 'John Griffin',
    email      => 'john.griffin@digital.cabinet-office.gov.uk',
    shell      => '/bin/zsh';
  }
  govuk::user { 'stevelaing':
    fullname   => 'Steve Laing',
    email      => 'steve.laing@digital.cabinet-office.gov.uk',
    shell      => '/bin/zsh';
  }
  govuk::user { 'i0n':
    fullname   => 'Ian Wood',
    email      => 'ian.wood@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'norm':
    fullname   => 'Mark Norman Francis',
    email      => 'mark.norman.francis@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'kief':
    fullname   => 'Kief Morris',
    email      => 'kmorris@thoughtworks.com';
  }
  govuk::user { 'rujmah':
    fullname   => 'Robin Mayfield',
    email      => 'robin.mayfield@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'ssheth':
    fullname   => 'Shodhan Sheth',
    email      => 'shodhan.sheth@digital.cabinet-office.gov.uk';
  }
  govuk::user { 'mneedham':
    fullname   => 'Mark Needham',
    email      => 'mark.needham@digital.cabinet-office.gov.uk';
  }

}
