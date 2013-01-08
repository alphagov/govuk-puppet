# == Class: users::groups::govuk
#
# Install and configure SSH access for GDS staff and contractors
#
class users::groups::govuk {

  ###################################################################
  #                                                                 #
  # When adding yourself to this list, please ensure that the list  #
  # remains sorted alphabetically by username.                      #
  #                                                                 #
  ###################################################################

  govuk::user { 'aaronkeogh':
    fullname => 'Aaron Keogh',
    email    => 'aaron.keogh@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'alex_tea':
    fullname => 'Alex Torrance',
    email    => 'alex.torrance@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'alext':
    fullname => 'Alex Tomlins',
    email    => 'alex.tomlins@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'annashipman':
    fullname => 'Anna Shipman',
    email    => 'anna.shipman@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'bradleyw':
    fullname => 'Bradley Wright',
    email    => 'bradley.wright@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'carlmassa':
    fullname => 'Carl Massa',
    email    => 'carl.massa@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'chrisheathcote':
    fullname => 'Chris Heathcote',
    email    => 'chris.heathcote@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'dafydd':
    fullname => 'Dafydd Vaughan',
    email    => 'dafydd.vaughan@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'dai':
    fullname => 'Dafydd Vaughan',
    email    => 'dafydd.vaughan@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'davidillsley':
    fullname => 'David Illsley',
    email    => 'david.illsley@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'davidt':
    fullname => 'David Thompson',
    email    => 'david.thompson@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'eddsowden':
    fullname => 'Edd Sowden',
    email    => 'edd.sowden@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'garethr':
    fullname => 'Gareth Rushgrove',
    email    => 'gareth.rushgrove@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'heathd':
    fullname => 'David Heath',
    email    => 'david.heath@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'henryhadlow':
    fullname => 'Henry Hadlow',
    email    => 'henry.hadlow@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'jabley':
    fullname => 'James Abley',
    email    => 'james.abley@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'james':
    fullname => 'James Stewart',
    email    => 'james.stewart@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'jamiec':
    fullname => 'Jamie Cobbett',
    email    => 'jamie.cobbett@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'johngriffin':
    fullname => 'John Griffin',
    email    => 'john.griffin@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'jordan':
    fullname => 'Jordan Hatch',
    email    => 'jordan.hatch@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'joshua':
    fullname => 'Joshua Marshall',
    email    => 'joshua.marshall@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'kushalp':
    fullname => 'Kushal Pisavadia',
    email    => 'kushal.pisavadia@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'maxf':
    fullname => 'Max Fliri',
    email    => 'mfliri@thoughtworks.com',
  }
  govuk::user { 'maxgriff':
    fullname => 'Max Griffiths',
    email    => 'max.griffiths@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'mazz':
    fullname => 'Mazz Mosley',
    email    => 'mazz.mosley@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'minglis':
    fullname => 'Martyn Inglis',
    email    => 'martyn.inglis@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'mwall':
    fullname => 'Mat Wall',
    email    => 'mat.wall@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'nick':
    fullname => 'Nick Stenning',
    email    => 'nick.stenning@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'norm':
    fullname => 'Mark Norman Francis',
    email    => 'mark.norman.francis@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'ops01':
    fullname => '2nd Line Support Secure Laptop Ops01',
    email    => '2nd-line-support@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'ops02':
    fullname => '2nd Line Support Secure Laptop Ops02',
    email    => '2nd-line-support@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'ops04':
    fullname => '2nd Line Support Secure Laptop Ops04',
    email    => '2nd-line-support@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'ppotter':
    fullname => 'Philip Potter',
    email    => 'philip.potter@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'psd':
    fullname => 'Paul Downey',
    email    => 'paul.downey@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'robyoung':
    fullname => 'Rob Young',
    email    => 'rob.young@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'rthorn':
    fullname => 'Russell Thorn',
    email    => 'russell.thorn@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'rujmah':
    fullname => 'Robin Mayfield',
    email    => 'robin.mayfield@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'ssharpe':
    fullname => 'Sam Sharpe',
    email    => 'sam.sharpe@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'stevelaing':
    fullname => 'Steve Laing',
    email    => 'steve.laing@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'timpaul':
    fullname => 'Tim Paul',
    email    => 'tim.paul@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'tombye':
    fullname => 'Tom Byers',
    email    => 'tom.byers@digital.cabinet-office.gov.uk',
  }
  govuk::user { 'tombyers':
    fullname => 'Tom Byers',
    email    => 'tom.byers@digital.cabinet-office.gov.uk',
  }

  # -------------------------------------------------------------------------

  # Ensure defunct users are absent
  govuk::user { [
    'craig',
    'i0n',
    'jamesweiner',
    'jgriffin',
    'kief',
    'mneedham',
    'paulb',
    'ssheth',
    'steve',
    'ukini',
  ]:
    ensure => absent
  }
}
