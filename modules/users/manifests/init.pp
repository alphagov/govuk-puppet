class users {
  include users::setup
  include users::govuk
}

class users::setup {
  include shell
  package { "zsh":
    ensure => latest,
  }
  group { "admin":
    name        => "admin",
    gid         => "3000",
  }
  user { "deploy":
    ensure      => present,
    home        => "/home/deploy",
    managehome  => true,
    shell       => '/bin/bash'
  }
  file { "/data":
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '755',
    require => User['deploy'],
  }
  ssh_authorized_key {
    "deploy_key_heathd":
      ensure => present,
      key    => extlookup("heathd_key", ""),
      type   => "ssh-rsa",
      user   => "deploy",
      require => User["deploy"];
    "deploy_key_fberriman":
      ensure  => present,
      key     => extlookup("fberriman_key", ""),
      type    => "ssh-dss",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_paulb":
      ensure  => present,
      key     => extlookup("paulb_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_garethr":
      ensure  => present,
      key     => extlookup("garethr_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_james":
      ensure  => present,
      key     => extlookup("james_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_mwall":
      ensure  => present,
      key     => extlookup("mwall_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
	  "deploy_key_jordanh":
      ensure  => present,
      key     => extlookup("jordanh_key", ""),
      type    => "ssh-dss",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_dafydd":
      ensure  => present,
      key     => extlookup("dafydd_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_jenkins":
      ensure  => present,
      key     => extlookup("jenkins_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_jamesweiner":
      ensure  => present,
      key     => extlookup("jamesweiner_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    }
}

class users::govuk {
  user { "craig":
    ensure     => absent
  }

  user { "mwall":
    comment => "Mat Wall (mat.wall@digital.cabinet-office.gov.uk)",
    ensure     => present,
    home       => "/home/mwall",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "mwall_key1":
    ensure  => present,
    key     => extlookup("mwall_key", ""),
    type    => "ssh-rsa",
    user    => "mwall",
    require => User["mwall"]
  }

  user { "dafydd":
    comment => "Dafydd Vaughan (dafydd.vaughan@digital.cabinet-office.gov.uk)",
    ensure     => present,
    home       => "/home/dafydd",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "dafydd_key1":
    ensure  => present,
    key     => extlookup("dafydd_key", ""),
    type    => "ssh-rsa",
    user    => "dafydd",
    require => User["dafydd"]
  }

  user { "garethr":
    comment => "Gareth Rushgrove (gareth.rushgrove@digital.cabinet-office.gov.uk)",
    ensure     => present,
    home       => "/home/garethr",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { "garethr_key1":
    ensure  => present,
    key     => extlookup("garethr_key", ""),
    type    => "ssh-rsa",
    user    => "garethr",
    require => User["garethr"]
  }

  user { "heathd":
    comment => "David Heath (david.heath@digital.cabinet-office.gov.uk)",
    ensure     => present,
    home       => "/home/heathd",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "heathd_key1":
    ensure  => present,
    key     => extlookup("heathd_key", ""),
    type    => "ssh-rsa",
    user    => "heathd",
    require => User["heathd"]
  }

  user { "james":
    comment => "James Stewart (james.stewart@digital.cabinet-office.gov.uk)",
    ensure  => present,
    home    => "/home/james",
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "james_key1":
    ensure  => present,
    key     => extlookup("james_key", ""),
    type    => "ssh-rsa",
    user    => "james",
    require => User["james"]
  }

  user { "joshua":
    comment => "Joshua Marshall (joshua.marshall@digital.cabinet-office.gov.uk)",
    ensure     => present,
    home       => "/home/joshua",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "joshua_key1":
    ensure  => present,
    key     => extlookup("joshua_key", ""),
    type    => "ssh-rsa",
    user    => "joshua",
    require => User["joshua"]
  }

  user { "paulb":
    comment    => "Paul Battley <paul.battley@digital.cabinet-office.gov.uk>",
    ensure     => present,
    home       => "/home/paulb",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/tcsh'
  }
  ssh_authorized_key { "paulb_kurosuke":
    ensure  => present,
    key     => extlookup("paulb_key", ""),
    type    => "ssh-rsa",
    user    => "paulb",
    require => User["paulb"],
  }

  user { "jamesweiner":
    comment    => "James Weiner <james.weiner@digital.cabinet-office.gov.uk>",
    ensure     => present,
    home       => "/home/jamesweiner",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "jamesweiner":
    ensure  => present,
    key     => extlookup("jamesweiner_key", ""),
    type    => "ssh-rsa",
    user    => "jamesweiner",
    require => User["jamesweiner"]
  }
}


class users::freerange {
  include users::setup
  user { "tomw":
    comment => "Tom Ward (tom.ward@gofreerange.co.uk)",
    ensure     => present,
    home       => "/home/tomw",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/zsh'
  }
  ssh_authorized_key { "tomw":
    ensure  => present,
    key     => extlookup("tomw_key", ""),
    type    => "ssh-rsa",
    user    => "tomw",
    require => User["tomw"]
  }

  user { "chrisroos":
    comment    => "Chris Roos <chris.roos@gofreerange.com>",
    ensure     => present,
    home       => "/home/chrisroos",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "chrisroos_key":
    ensure  => present,
    key     => extlookup("chrisroos_key", ""),
    type    => "ssh-rsa",
    user    => "chrisroos",
    require => User["chrisroos"],
  }

  user { "jasoncale":
    comment    => "Jason Cale <jason.cale@gofreerange.com>",
    ensure     => present,
    home       => "/home/jasoncale",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "jasoncale":
    ensure  => present,
    key     => extlookup("jasoncale_key", ""),
    type    => "ssh-rsa",
    user    => "jasoncale",
    require => User["jasoncale"],
  }

  user { "jamesmead":
    comment => "James Mead (james@floehopper.org)",
    ensure     => present,
    home       => "/home/jamesmead",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "jamesmead_key1":
    ensure  => present,
    key     => extlookup("jamesmead_key", ""),
    type    => "ssh-rsa",
    user    => "jamesmead",
    require => User["jamesmead"]
  }

  user { "lazyatom":
    comment => "James Adam (james.adam@gofreerange.com)",
    ensure     => present,
    home       => "/home/lazyatom",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "lazyatom_key1":
    ensure  => present,
    key     => extlookup("lazyatom_key", ""),
    type    => "ssh-rsa",
    user    => "lazyatom",
    require => User["lazyatom"]
  }

  ssh_authorized_key {
    "deploy_key_jamesmead":
      ensure  => present,
      key     => extlookup("jamesmead_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_lazyatom":
      ensure  => present,
      key     => extlookup("lazyatom_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_chrisroos":
      ensure  => present,
      key     => extlookup("chrisroos_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_jasoncale":
      ensure  => present,
      key     => extlookup("jasoncale_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
    "deploy_key_tomw":
      ensure  => present,
      key     => extlookup("tomw_key", ""),
      type    => "ssh-rsa",
      user    => "deploy",
      require => User["deploy"];
  }

}

class users::other {
  user { "tomstuart":
    comment    => "Tom Stuart <tom@experthuman.com>",
    ensure     => present,
    home       => "/home/tomstuart",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "tomstuart_key1":
    ensure  => present,
    key     => extlookup("tomstuart_key", ""),
    type    => "ssh-rsa",
    user    => "tomstuart",
    require => User["tomstuart"]
  }
  ssh_authorized_key { "deploy_key_tomstuart":
    ensure  => present,
    key     => extlookup("tomstuart_key", ""),
    type    => "ssh-rsa",
    user    => "deploy",
    require => User["deploy"];
  }
}

# Office of the public guardian, LPA project
class users::opg {
  include users::setup

  user { "alister":
    comment => "Alister Bulman (alister.bulman@betransformative.com)",
    ensure     => present,
    home       => "/home/alister",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "alister_key1":
    ensure  => present,
    key     => extlookup("alister_key", ""),
    type    => "ssh-rsa",
    user    => "alister",
    require => User["alister"]
  }

  user { "chrismo2012":
    comment => "Chris Moreton (chris.moreton@betransformative.com)",
    ensure     => present,
    home       => "/home/chrismo2012",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "chrismo2012_key1":
    ensure  => present,
    key     => extlookup("chrismo2012_key", ""),
    type    => "ssh-rsa",
    user    => "chrismo2012",
    require => User["chrismo2012"]
  }

  user { "jamie":
    comment => "jamie (Jamie.Burns@betransformative.com)",
    ensure     => present,
    home       => "/home/jamie",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "jamie_key1":
    ensure  => present,
    key     => extlookup("jamie_key", ""),
    type    => "ssh-rsa",
    user    => "jamie",
    require => User["jamie"]
  }
}

class users::ertp {
  include users::setup

  user { "jameshu":
    comment => "James Hughes (j.hughes@kainos.com)",
    ensure     => present,
    home       => "/home/jameshu",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "jamehsu_key1":
    ensure  => present,
    key     => extlookup("jameshu_key", ""),
    type    => "ssh-rsa",
    user    => "jamehsu",
    require => User["jameshu"]
  }

  user { "michaela":
    comment => "Michael Allen (m.allen@kainos.com)",
    ensure     => present,
    home       => "/home/michaela",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "michaela_key1":
    ensure  => present,
    key     => extlookup("michaela_key", ""),
    type    => "ssh-rsa",
    user    => "micheala",
    require => User["michaela"]
  }

  user { "leszekg":
    comment => "Leszek Gonczar (l.gonczar@kainos.com)",
    ensure     => present,
    home       => "/home/leszekg",
    managehome => true,
    groups     => ["admin", "deploy"],
    require    => Class["users::setup"],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { "leszekg_key1":
    ensure  => present,
    key     => extlookup("leszekg_key", ""),
    type    => "ssh-rsa",
    user    => "leszekg",
    require => User["leszekg"]
  }
}
